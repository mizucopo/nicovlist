# coding: utf-8
class CreateMylists < ActiveRecord::Migration
  def change
    create_table :mylists do |t|
      t.integer :year,      null: false
      t.integer :month,     null: false
      t.integer :day,       null: false
      t.string  :name,      null: false
      t.string  :mylist_id, null: false

      t.timestamps
    end
  end
end
