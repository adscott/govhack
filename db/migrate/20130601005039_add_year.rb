class AddYear < ActiveRecord::Migration
  def up
    change_table :data_points do |t|
        t.integer :year
    end
  end

  def down
    change_table :data_points do |t|
        t.remove :year
    end
  end
end
