class DataPointsHaveToggleForSdrAndHumanCost < ActiveRecord::Migration
  def up
    change_table :data_points do |t |
        t.boolean :has_standard_death_rate, :default => 0
        t.boolean :has_potential_years_lost, :default => 0
    end
  end

  def down
    change_table :data_points do |t|
        t.remove :has_standard_death_rate
        t.remove :has_potential_years_lost
    end
  end
end
