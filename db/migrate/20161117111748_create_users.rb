class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,  null: false, default: ""
      ## Devise stuff
      t.string :encrypted_password, null: false, default: ""
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      t.string :name
      t.integer :company_id
      t.string :auth_token, default: ""
      t.timestamps
    end
    add_index :users, :email,  unique: true
    add_index :users, :auth_token,  unique: true
    add_index :users, :company_id
  end
end
