ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require_relative 'models/link'

class BookmarkManager < Sinatra::Base

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    Link.create(url: params[:url], title: params[:title])
    redirect to('/links')
  end

  get '/links/new' do
    erb :'links/new'
  end
end
