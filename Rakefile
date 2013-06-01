require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

task :establish_connection do
  require 'active_record'
  require 'logger'
  require './models/data_point'
  ActiveRecord::Base.configurations = YAML::load(ERB.new(File.read('config/database.yml')).result)
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')
end

def row_to_hash(row, year)
  {:category => row[0], :males => row[2], :females => row[3], :persons => row[4], :year => year}
end

def import_current_year(spreadsheet, year)
  rows = []
  spreadsheet.worksheet(1).each(11) { |row| rows << row }
  rows
    .reject { |row| row_to_hash(row, year)[:males].nil? }
    .map do |row|
      {
        indentation: row.format(0).indent_level - 1,
        data: row_to_hash(row, year)
      }
    end
    .reject { |row| row[:indentation] < 0 }
    .reduce([]) do |memo, row|
      memo = memo.slice(0, row[:indentation]) || []
      memo[row[:indentation]] = row[:data][:category]
      DataPoint.new(row[:data].merge({:category => memo.join(' > ')})).save
      memo
    end
end
task :insert_data => [:establish_connection] do
  DataPoint.delete_all

  require 'spreadsheet'
  path = './data/3303.0_1 underlying causes of death (australia) password removed.xls'
  year = 2011
  spreadsheet = Spreadsheet.open(path)
  import_current_year(spreadsheet, year)
end


task :load_deathcards => [:establish_connection] do
  # remove existing cards...
  require 'yaml'
  Dir.glob("data/deathcards/*.yaml") do | card_yaml |
    card_data = YAML.load_file(card_yaml)
    puts "Loaded #{card_data['title']}"
    # load card into migration
    # Check for unique slug?
  end
end


task :show_all => [:establish_connection] do
  DataPoint.all.each { |d| puts d.category }
end


