class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, default: ""
      t.integer :user_id
      t.integer :company_id
      t.boolean :private, default: false
      t.boolean :complete, default: false
      t.timestamps
    end
    add_index :tasks, :user_id
    add_index :tasks, :company_id
  end
end
