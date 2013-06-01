class Card < ActiveRecord::Base
    has_many :data_points, foreign_key:"category",primary_key:"category",order: :year
end