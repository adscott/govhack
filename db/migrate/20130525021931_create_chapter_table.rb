class CreateChapterTable < ActiveRecord::Migration
  def up
    create_table :chapters do |t|
      t.string :name
      t.integer :males
      t.integer :females
      t.integer :persons
    end
  end

  def down
    drop_table :chapters
  end
end
