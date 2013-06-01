require 'sinatra'
require 'haml'
require 'active_record'
require './models/data_point'

ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')

get '/' do
  haml :index, locals: { data_points: DataPoint.top_level }
end

get '/data_point/:id' do |id|
  haml :data_point, locals: { data_point: DataPoint.find(id) }
end
