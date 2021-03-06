class CreateMyForumTopics < ActiveRecord::Migration
  def change
    create_table :my_forum_topics do |t|
      t.integer :forum_id
      t.integer :user_id
      t.integer :latest_post_id
      t.string  :name
      t.string  :description
      t.integer :views
      t.integer :posts_count, default: 0
      t.boolean :pinned, default: false
      t.boolean :closed, default: false
      t.boolean :deleted, default: false
      t.timestamps null: false
    end
  end
end
