class CreateMyForumTopics < ActiveRecord::Migration
  def change
    create_table :my_forum_topics do |t|
      t.integer :forum_id
      t.string  :name
      t.string  :description
      t.timestamps
    end
  end
end
