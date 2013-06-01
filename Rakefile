require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

task :establish_connection do
  require 'active_record'
  require 'logger'
  require './models/data_point'
  require './models/card'
  ActiveRecord::Base.configurations = YAML::load(ERB.new(File.read('config/database.yml')).result)
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')
end

def row_to_hash(row, year)
  {:category => row[0], :males => row[2], :females => row[3], :persons => row[4], :year => year}
end

def row_to_hashes(row)
  return nil if( row[2].nil?)
  {
    row:row,
    category:row[0],
    data: (2002..2010).map do | year |
      index = year - 2002
      columns_per_year=4
      offset = index * columns_per_year + 2

      {:males => row[offset], :females => row[offset+1], :persons => row[offset+2], :year => year}
    end
  }
end

def import_current_year(worksheet, year)
  rows = []
  worksheet.each(11) { |row| rows << row }
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
      memo[row[:indentation]] = row[:category]
      DataPoint.new(row[:data].merge({:category => memo.join(' > ')})).save
      memo
    end
end

def import_past_years(worksheet)
  rows = []
  worksheet.each(11) { | row | rows << row }
  rows
    .map do | row | row_to_hashes( row ) end
    .reject { | hash | hash.nil? }
    .map do | hash |
      h = hash.merge( { indentation:hash[:row].format(0).indent_level-1})
      h.delete(:row)
      h
    end
    .reject { | hash | hash[:indentation] < 0 }
    .reduce([]) do | memo, row |
      memo = memo.slice(0, row[:indentation]) || []
      memo[row[:indentation]] = row[:category]
      shared_data = {category:memo.join(' > ')}

      row[:data].each do | dp |
        DataPoint.new(dp.merge(shared_data)).save
      end
      memo
    end

end
task :insert_data => [:establish_connection] do
  DataPoint.delete_all

  require 'spreadsheet'
  path = './data/3303.0_1 underlying causes of death (australia) password removed.xls'
  year = 2011
  spreadsheet = Spreadsheet.open(path)
  import_current_year(spreadsheet.worksheet(1), year)
  import_past_years(spreadsheet.worksheet(2))
end


task :load_deathcards => [:establish_connection] do
  Card.delete_all
  require 'yaml'
  Dir.glob("data/deathcards/*.yaml") do | card_yaml |
    card_data = YAML.load_file(card_yaml)
    Card.new(card_data).save
    puts "Loaded #{card_data['title']}"
    # load card into migration
    # Check for unique slug?
  end
end


task :show_all => [:establish_connection] do
  DataPoint.all.each { |d| puts d.category }
end


