require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

task :establish_connection do
  require 'active_record'
  require 'logger'
  require './models/data_point'
  ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'] || 'development')
end

CHAPTER_INDENT_LEVEL = 1
SECTION_INDENT_LEVEL = 2
CAUSE_INDENT_LEVEL = 3

def row_to_hash(row)
  {:category => row[0], :males => row[2], :females => row[3], :persons => row[4]}
end

task :insert_data => [:establish_connection] do
  DataPoint.delete_all

  require 'spreadsheet'
  path = './data/3303.0_1 underlying causes of death (australia) password removed.xls'
  rows = []
  Spreadsheet.open(path).worksheet(1).each(11) { |row| rows << row }

  rows
    .reject { |row| row_to_hash(row)[:males].nil? }
    .map { |row| {indentation: row.format(0).indent_level - 1, data: row_to_hash(row)} }
    .reject { |row| row[:indentation] < 0 }
    .reduce([]) do |memo, row|
      memo = memo.slice(0, row[:indentation]) || []
      memo[row[:indentation]] = row[:data][:category]
      DataPoint.new(row[:data].merge({:category => memo.join(' > ')})).save
      memo
    end
end

task :show_all => [:establish_connection] do
  DataPoint.all.each { |d| puts d.category }
end


