require 'standalone_migrations'
StandaloneMigrations::Tasks.load_tasks

task :establish_connection do
  require 'active_record'
  require 'sqlite3'
  require 'logger'
  require './models/chapter'
  require './models/section'
  require './models/cause'
  ActiveRecord::Base.logger = Logger.new('debug.log')
  ActiveRecord::Base.configurations = YAML::load(IO.read('db/config.yml'))
  ActiveRecord::Base.establish_connection('development')
end

CHAPTER_INDENT_LEVEL = 1
SECTION_INDENT_LEVEL = 2
CAUSE_INDENT_LEVEL = 3

def row_to_hash(row)
  {:name => row[0], :males => row[2], :females => row[3], :persons => row[4]}
end

task :insert_data => [:establish_connection] do
  Cause.delete_all
  Section.delete_all
  Chapter.delete_all

  require 'spreadsheet'
  path = './data/3303.0_1 underlying causes of death (australia) password removed.xls'
  rows = []
  Spreadsheet.open(path).worksheet(1).each(11) { |row| rows << row }

  chapter_processor = lambda { |row| Chapter.new(row_to_hash(row)).save }
  section_processor = lambda { |row| Chapter.last.sections.create(row_to_hash(row)) }
  cause_processor = lambda { |row| Chapter.last.sections.last.causes.create(row_to_hash(row)) }

  processors = {
    CHAPTER_INDENT_LEVEL => chapter_processor,
    SECTION_INDENT_LEVEL => section_processor,
    CAUSE_INDENT_LEVEL => cause_processor
  }

  rows
    .select { |row| processors.has_key?(row.format(0).indent_level) }
    .each { |row| processors[row.format(0).indent_level].call(row) }
end

task :show_all => [:establish_connection] do
  Cause.all.each { |c| puts "Chapter: #{c.section.chapter.name}\nSection: #{c.section.name}\nCause: #{c.name}\n" }
end


