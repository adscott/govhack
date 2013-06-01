class DataPoint < ActiveRecord::Base

  SEPARATOR = ' > '

  def name
    category.split(' > ').last
  end

  def children
    DataPoint
      .where('category LIKE ?', "#{category}#{SEPARATOR}%")
      .select { |point| point.category.split(SEPARATOR).length == (category.split(SEPARATOR).length + 1) }
  end

  def self.top_level
    DataPoint.all.reject { |point| point.category.include? SEPARATOR }
  end

end
