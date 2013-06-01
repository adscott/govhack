class DataPoint < ActiveRecord::Base

  SEPARATOR = ' > '

  def name
    category.split(' > ').last
  end

  def children
    DataPoint
      .where('category LIKE ?', "#{category}#{SEPARATOR}%")
      .where( :year => year)
      .select { |point| point.category.split(SEPARATOR).length == (category.split(SEPARATOR).length + 1) }
  end

  def self.top_level(year)
    DataPoint.where('category NOT LIKE ?', "%#{SEPARATOR}%").where(:year => year)
  end

end
