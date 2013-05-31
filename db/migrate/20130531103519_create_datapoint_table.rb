class CreateDatapointTable < ActiveRecord::Migration
  def up
    create_table :data_points do |t|
      t.string :category
      t.integer :males
      t.integer :females
      t.integer :persons
    end
  end

  def down
    drop_table :data_points
  end
end
