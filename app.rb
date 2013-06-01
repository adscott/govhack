require 'sinatra'
require 'haml'
require 'active_record'
require './models/data_point'
require './models/card'

ActiveRecord::Base.configurations = YAML::load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')

get '/' do
  card1 = Card.first(:offset => rand(Card.count))
  card2 = Card.first(:offset => rand(Card.count))

  if card1.id == card2.id
    redirect to '/'
  else
    redirect to "/compare/#{card1.slug}/vs/#{card2.slug}"
  end
end

get '/search' do
  term = params[:term]
  haml :search_results, locals: {data_points: DataPoint.where(year: 2011).select { |dp| dp.name.downcase.include? term.downcase }}
end

get '/year/:year' do | year |
  axes = {
    year: DataPoint.select(:year).uniq.order(:year).map do | dp |
        {
            href: "/year/#{dp.year}",
            text: dp.year,
            value: dp.year
        }
        end
  }
  haml :index, locals: { data_points: DataPoint.top_level(year), axes:axes, current:year }
end

get '/card/:slug' do | slug |
  haml :card, locals: { card: Card.where(slug:slug).first, body_class: 'card-single' }
end


get '/data_point/:id' do |id|
  dp = DataPoint.find(id)
  axes = {
    year: DataPoint.where(:category => dp.category).map do | dp |
            {
                href: "/data_point/#{dp.id}",
                text: dp.year,
                value: dp.year
            }
        end
  }
  haml :data_point, locals: { data_point: dp, axes:axes }
end

get '/game' do
  haml :game, locals: { data_points: DataPoint.top_level }
end

get '/card' do
  haml :cards, locals: { cards: Card.find(:all) }
end

get '/compare/:firstslug/vs/:secondslug' do | firstslug, secondslug |
  haml :compare, locals: { first: Card.where(slug:firstslug).first, second: Card.where(slug:secondslug).first }
end

get '/stylesheets/:stylesheet.css' do |stylesheet|
  scss :"stylesheets/#{stylesheet}"
end
