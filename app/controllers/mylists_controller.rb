# coding: utf-8
class MylistsController < ApplicationController
  def index
    @mylists = Mylist.all
    render :json => @mylists
  end
end
