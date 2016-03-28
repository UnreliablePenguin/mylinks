require 'sinatra'
require 'uri'
require 'active_record'

set :public_folder, 'public'

db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///myvideos')

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

class Video < ActiveRecord::Base
  has_many :comments, dependent: :destroy
end
 
class Comment < ActiveRecord::Base
  belongs_to :video
end


get '/' do
  @videos = Video.order("id DESC")
  puts @videos
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

get '/video&watch_v=:vid' do
  @comments = Comment.where(video_id: params['vid'])
  @video = Video.where(id: params['vid'])
  puts @video
  erb :video
end

post '/video&watch_v=:vid' do 
  comment = params[:comment]
  comment['video_id'] = params['vid']
  comment['author'] = "Anonymous"
  newComment = Comment.new(comment)
  puts comment
  if newComment.save(comment)
    redirect to "/video&watch_v=" + params['vid']
  else
    return "failure!"
  end
end

post '/create' do
  
  #I CHANGED A BUNCH OF STUFF HERE DO NOT FORGET
  video = params[:video]
 # video[link] = video[link].to_s.slice(/[A-Z|0-9]{10,12}/i)
  puts video
  newVid = Video.new(video)
  if newVid.save
    @video = newVid
    redirect to "/video&watch_v=#{newVid.id}"
  else
    return "failure!"
  end
end


def getID(url)
  #https://www.youtube.com/watch?v=AAsICMPwGPY
  return url.slice(/([A-Z])\w+/)
end