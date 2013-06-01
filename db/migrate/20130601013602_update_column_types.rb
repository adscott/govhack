class UpdateColumnTypes < ActiveRecord::Migration
  def up
      change_column :data_points, :category, :text, :limit => 4096
  end
  def down
      change_column :data_points, :category, :string
  end
end
