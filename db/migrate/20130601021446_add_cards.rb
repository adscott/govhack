class AddCards < ActiveRecord::Migration
  def up
    create_table :cards do | t |
        t.text :title
        t.text :description, :limit => 4096
        t.text :image
        t.text :category
    end
  end

  def down
    drop_table :cards
  end
end
