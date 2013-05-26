require 'sinatra'
require 'haml'
require 'active_record'
require 'sqlite3'
require 'logger'
require './models/chapter'
require './models/section'
require './models/cause'

ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection('development')

get '/' do
  haml :index, locals: { chapters: Chapter.all }
end

get '/chapter/:id' do |id|
  haml :chapter, locals: { chapter: Chapter.find(id) }
end

get '/section/:id' do |id|
  haml :section, locals: { section: Section.find(id) }
end
