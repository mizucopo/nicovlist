# coding: utf-8
require 'test_helper'
class MylistTest < ActiveSupport::TestCase
  test "get ranking items" do
    mylist = Mylist.new
    items = mylist.get_ranking_items
    assert items.kind_of?(Array)
    assert 0 < items.size
  end

=begin
  test "nicovideo login" do
    mylist  = Mylist.new
    cookie = mylist.nicovideo_login
    
    regexp = Regexp.new('^user_session=')
    assert regexp.match cookie
  end

  test "nicovide get token" do
    mylist = Mylist.new
    cookie = mylist.nicovideo_login
    token  = mylist.nicovideo_token cookie
    
    regexp = Regexp.new('^[\d\w-]+$')
    assert regexp.match token
  end

  test "nicovideo mylistgroup add and delete" do
    mylist = Mylist.new
    cookie = mylist.nicovideo_login
    token  = mylist.nicovideo_token cookie

    dt   = Time.now
    name = "#{dt.year}#{dt.month}#{dt.day}#{dt.hour}#{dt.min}#{dt.sec}"

    id = mylist.nicovideo_mylistgroup_add cookie, token, name
    
    regexp = Regexp.new('^[\d]+$')
    assert regexp.match id.to_s

    assert mylist.nicovideo_mylist_add cookie, token, id, 'sm9'
    
    assert mylist.nicovideo_mulistgroup_delete cookie, token, id
  end

  test "nicovideo mylistgroup list" do
    mylist = Mylist.new
    cookie = mylist.nicovideo_login
    token  = mylist.nicovideo_token cookie
    
    ids = mylist.nicovideo_mylistgroup_list cookie, token
    assert ids.kind_of?(Array)
  end
=end

  test "create mylist" do
    mylist = Mylist.new
    id = mylist.create_mylist
    assert mylist.id.kind_of?(Fixnum)
  end
end
