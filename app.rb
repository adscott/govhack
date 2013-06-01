require 'sinatra'
require 'haml'
require 'active_record'
require './models/data_point'
require './models/card'

ActiveRecord::Base.configurations = YAML::load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')

get '/' do
  redirect to "/year/2011"
end

get '/year/:year' do | year |
  axes = {
    year: DataPoint.select(:year).uniq.map do | dp |
        {
            href: "/year/#{dp.year}",
            text: dp.year
        }
        end
  }
  haml :index, locals: { data_points: DataPoint.top_level(year), axes:axes }
end

get '/card/:id' do | id |
  haml :card, locals: { card: Card.find(id) }
end

get '/data_point/:id' do |id|
  dp = DataPoint.find(id)
  axes = {
    year: DataPoint.where(:category => dp.category).map do | dp |
            {
                href: "/data_point/#{dp.id}",
                text: dp.year
            }
        end
  }
  haml :data_point, locals: { data_point: dp, axes:axes }
end
