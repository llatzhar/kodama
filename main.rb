require 'rss'
require 'rubygems'
require 'sinatra'
require 'sequel'

#$LOAD_PATH.unshift(File.dirname(__FILE__) + '/vendor/json_pure')
#require 'json/pure'

configure do
   # TIP:  You can get you database information
   #       from ENV['DATABASE_URI'] (see /env route below)
   DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://bookmarks.db')
end


get '/' do
   ds = DB[:bookmarks].limit(30)
   
   records = []
   ds.each do |r|
      puts "test: #{r[:title]}"
   end
   erb :bookmarks, :locals => {
      :records => ds
   }
end

get '/new' do
   erb :new_bookmark, :locals => {
      :hints => params
   }
end

post '/new' do
   DB[:bookmarks].insert({
      :title => params[:title],
      :url => params[:url],
      :tag => params[:tag],
      :note => params[:note],
      :user_id => 0
   })
   redirect '/'
end

get '/rss' do
   bookmarks = DB[:bookmarks].limit(30)
   
   rss = RSS::Maker.make("2.0") do |maker|

      maker.channel.about = "http://localhost:9292/"
      maker.channel.title = "kodama"
      maker.channel.description = "New Arrivals for kodama."
      maker.channel.link = "http://localhost:9292/"

      maker.items.do_sort = true
      
      bookmarks.each do |bookmark|
         item = maker.items.new_item
         item.link = bookmark[:url]
         item.title = bookmark[:title]	#TODO escape
         #item.date = m.modified_at
         item.description = bookmark[:notes]	#TODO escape
      end
   end
   rss.to_s
end

get '/env' do
   ENV.inspect
end
