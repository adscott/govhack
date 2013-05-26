class CreateTables < ActiveRecord::Migration
  def up
    create_table :chapters do |t|
      t.string :name
      t.integer :males
      t.integer :females
      t.integer :persons
    end

    create_table :sections do |t|
      t.integer :chapter_id
      t.string :name
      t.integer :males
      t.integer :females
      t.integer :persons
    end

    create_table :causes do |t|
      t.integer :section_id
      t.string :name
      t.integer :males
      t.integer :females
      t.integer :persons
    end
  end

  def down
    drop_table :causes
    drop_table :sections
    drop_table :chapters
  end
end
