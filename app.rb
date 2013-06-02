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

#
#card.data_points.reverse.each do | dp |
#  %tr
#  %td= dp.year
#  %td.center= dp.males
#  %td.center= dp.females
#  %td.center= dp.persons


#sample = [
#    {
#        "color": "blue",
#    "name": "New York",
#    "data": [ { "x": 2001, "y": 40 }, { "x": 1, "y": 49 }, { "x": 2, "y": 38 }, { "x": 3, "y": 30 }, { "x": 4, "y": 32 } ]
#}, {
#    "name": "London",
#    "data": [ { "x": 0, "y": 19 }, { "x": 1, "y": 22 }, { "x": 2, "y": 29 }, { "x": 3, "y": 20 }, { "x": 4, "y": 14 } ]
#}, {
#    "name": "Tokyo",
#    "data": [ { "x": 0, "y": 8 }, { "x": 1, "y": 12 }, { "x": 2, "y": 15 }, { "x": 3, "y": 11 }, { "x": 4, "y": 10 } ]
#}
#]
#
get '/compare/:firstslug/vs/:secondslug/json' do | firstslug, secondslug |
  require 'json'
  content_type :json
  first = Card.where(slug:firstslug).first
  first_by_year = []
  first.data_points.reverse.each do | dp |
    first_by_year << { :year => dp.year, :deaths => dp.persons }
  end

  second = Card.where(slug:secondslug).first
  second_by_year = []
  second.data_points.reverse.each do | dp |
    second_by_year << { :year => dp.year, :deaths => dp.persons }
  end

  return [
      {:name => first.title,
       :data => first_by_year},
      {:name => second.title,
       :data => second_by_year}
  ].to_json

end

get '/stylesheets/:stylesheet.css' do |stylesheet|
  scss :"stylesheets/#{stylesheet}"
end
