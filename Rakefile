require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

task :establish_connection do
  require 'active_record'
  require 'sqlite3'
  require 'logger'
  require './models/chapter'
  ActiveRecord::Base.logger = Logger.new('debug.log')
  ActiveRecord::Base.configurations = YAML::load(IO.read('db/config.yml'))
  ActiveRecord::Base.establish_connection('development')
end

task :insert_data => [:establish_connection] do
  Chapter.delete_all

  require 'spreadsheet'
  path = './data/3303.0_1 underlying causes of death (australia) password removed.xls'
  rows = []
  Spreadsheet.open(path).worksheet(1).each(11) { |row| rows << row }

  rows
    .select { |row| row.format(0).indent_level == 1 }
    .map { |row| Chapter.new(:name => row[0], :males => rows[2], :females => rows[3], :persons => rows[4]) }
    .each { |chapter| chapter.save }
end

task :show_all => [:establish_connection] do
  puts Chapter.all.map { |c| c.name }
end
