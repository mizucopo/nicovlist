# coding: utf-8
class Mylist < ActiveRecord::Base
  attr_accessible :day, :month, :name, :mylist_id, :year
  
  # ニコニコ動画のマイリストを作成します。
  def create_mylist
    # 登録する動画リストを取得
    items = get_ranking_items

    # ニコニコ動画にログイン
    cookie = nicovideo_login
    token  = nicovideo_token cookie
    
    # マイリストの作成
    dt   = Time.now
    name = "#{dt.year}/#{dt.month}/#{dt.day} のマイリスト"
    id   = nicovideo_mylistgroup_add cookie, token, name
    
    # マイリストに動画を登録
    items.each { |item|
      nicovideo_mylist_add cookie, token, id, item[:id]
    }
    
    # データベースにマイリストを登録
    self.year      = dt.year
    self.month     = dt.month
    self.day       = dt.day
    self.name      = name
    self.mylist_id = id

    self.transaction do
      self.save!
    end
    
    return self.id
  end
  
  # RSS からアイテムを取得
  def get_ranking_items
    require 'rss'
  
    rss = open(Nicovlist::Application.config.nicovideo_rss) { |file| RSS::Parser.parse(file.read) }
    
    items = []
    rss.items.each { |item|
      # item_id を取り出す
      idx = item.link.rindex('/') + 1
      len = item.link.length - (item.link.length - idx)
      item_id = item.link[idx, len]

      items.push({
        :name => item.title,
        :url  => item.link,
        :id   => item_id,
      })
    }
    
    return items
  end
  
  # ニコニコ動画のAPIにアクセスするCookieを返します。
  def nicovideo_login()
    require 'net/https'

    mail     = Nicovlist::Application.config.nicovideo_mail
    password = Nicovlist::Application.config.nicovideo_password
    
    host = 'secure.nicovideo.jp'
    path = '/secure/login?site=niconico'
    body = "mail=#{mail}&password=#{password}"
    
    https = Net::HTTP.new(host, 443)
    https.use_ssl = true
    # TODO : VERIFY_NONE にしない
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = https.start { |https|
	  https.post(path, body)
    }
    
    cookie = ''
    unless response['set-cookie'].nil?
	  response['set-cookie'].split('; ').each do |st|
	    if idx = st.index('user_session_')
	      cookie = "user_session=#{st[idx..-1]}"
	      break
	    end
	  end
	end
    
    return cookie
  end
  
  # Nicovideo Token 取得 (書き込み処理には必要)
  def nicovideo_token(cookie)
    response = nicovideo_api_request('/my/mylist', 'get', cookie)
    regex    = Regexp.new('NicoAPI\.token = "([\d\w-]+)";')
    match    = regex.match response.body
    return match[1]
  end
  
  # Nicovideo MylistGroup 一覧を取得
  def nicovideo_mylistgroup_list(cookie, token)
    require 'json'

    response = nicovideo_api_request('/api/mylistgroup/list', 'get', cookie)
    body = JSON.parse(response.body)
    ids  = []
    body['mylistgroup'].each {|mg|
      ids.push mg['id']
    }

    return ids
  end
  
  # Nicovideo マイリストを新規作成
  def nicovideo_mylistgroup_add(cookie, token, mylist_name)
    require 'json'
    
    response = nicovideo_api_request('/api/mylistgroup/add', 'post', cookie, {
      :name         => mylist_name,
      :description  => 'nicovlistから自動的に作成しております。',
      :public       => 1,
      :default_sort => 0,
      :icon_id      => 0,
      :token        => token,
    })
    body = JSON.parse(response.body)

    return body['id']
  end
  
  # Nicovideo マイリストの削除
  def nicovideo_mulistgroup_delete(cookie, token, id)
    require 'json'
    
    response = nicovideo_api_request('/api/mylistgroup/delete', 'post', cookie, {
      :group_id     => id,
      :token        => token,
    })
    body = JSON.parse(response.body)
    if 'ok' != body['status']
      raise "Response Status Error"
    end
    
    return true
  end
  
  # Nicovideo マイリストに動画を追加
  def nicovideo_mylist_add(cookie, token, mylist_id, item_id)
    require 'json'
    
    response = nicovideo_api_request('/api/mylist/add', 'post', cookie, {
      :group_id    => mylist_id,
      :item_type   => 0,
      :item_id     => item_id,
      :description => '',
      :token       => token,
    })
    body = JSON.parse(response.body)
    if 'ok' != body['status']
     raise "Response Status Error"
    end
    
    return true
  end
  
  # Nicovideo API リクエスト
  def nicovideo_api_request(endpoint, method, cookie, form_data = nil)
    require 'net/http'

    http = Net::HTTP.new('www.nicovideo.jp', 80)
    response = http.start { |http|
      case method
      when 'get'
        request = Net::HTTP::Get.new(endpoint)
      when 'post'
        request = Net::HTTP::Post.new(endpoint)
      else
        raise "method unknown"
      end
      
      request['cookie'] = cookie
      
      unless form_data.nil?
        request.set_form_data(form_data)
      end
      http.request(request)
    }

    if '200' != response.code
      raise "Response Error"
    end
    
    # サーバーにやさしく
    sleep 1
    
    return response
  end
  private :nicovideo_api_request
end
