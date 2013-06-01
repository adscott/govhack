class CardsHaveSlugs < ActiveRecord::Migration
  def up
    change_table :cards do | t |
        t.text :slug, unique:true
    end
  end

  def down
    change_table :cards do | t |
        t.remove :slug
    end
  end
end
