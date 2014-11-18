class CreateMyForumForums < ActiveRecord::Migration
  def change
    create_table :my_forum_forums do |t|
      t.integer :category_id
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
