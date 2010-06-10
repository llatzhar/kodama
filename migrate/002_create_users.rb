class CreateUsers < Sequel::Migration
   def up
      create_table :users do
         primary_key :id
         String :profile
         String :name
         String :password
      end
   end
   def down
      drop_table :users
   end
end
