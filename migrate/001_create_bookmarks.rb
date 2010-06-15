class CreateBookmarks < Sequel::Migration
   def up
      create_table :bookmarks do
         primary_key :id
         String :title
         String :url, :size => 2048
         String :tag, :size => 2048
         String :note, :size => 2048
         Fixnum :user_id
      end
   end
   def down
      drop_table :bookmarks
   end
end
