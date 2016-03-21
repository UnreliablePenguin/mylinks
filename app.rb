require 'sinatra'
require 'uri'
require 'active_record'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///mylinks')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

class Link < ActiveRecord::Base
end

get '/' do
  @links = Link.order("id DESC")
  erb :index
end

post '/watch' do
end

get '/submit' do
  erb :create
end

get '/about' do
  erb :about
end

post '/create' do
  
  
  link = Link.new(params[:link])
  if link.save
    redirect to "/"
  else
    return "failure!"
  end
end


def getID(url)
  #https://www.youtube.com/watch?v=AAsICMPwGPY
  return url.slice(/([A-Z])\w+/)
end