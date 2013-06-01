require 'sinatra'
require 'haml'
require 'active_record'
require 'sqlite3'
require 'logger'
require './models/data_point'

ActiveRecord::Base.logger = Logger.new('debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read('db/config.yml'))
ActiveRecord::Base.establish_connection('development')

get '/' do
  haml :index, locals: { data_points: DataPoint.top_level }
end

get '/data_point/:id' do |id|
  haml :data_point, locals: { data_point: DataPoint.find(id) }
end

get '/game' do
  haml :game, locals: { data_points: DataPoint.top_level }
end