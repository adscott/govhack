class DataPointsHaveSdrAndHumanCost < ActiveRecord::Migration
  def up
    change_table :data_points  do | t |
        t.text :standard_death_rate_males, null: true
        t.text :standard_death_rate_females, null: true
        t.text :standard_death_rate_persons, null: true
        t.text :potential_years_lost_males, null: true
        t.text :potential_years_lost_females, null: true
        t.text :potential_years_lost_persons, null: true
    end
  end

  def down
    change_table :data_points  do | t |
        t.remove :standard_death_rate_males
        t.remove :standard_death_rate_females
        t.remove :standard_death_rate_persons
        t.remove :potential_years_lost_males
        t.remove :potential_years_lost_females
        t.remove :potential_years_lost_persons
    end
  end
end
