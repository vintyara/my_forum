module MyForum
  class Post < ActiveRecord::Base
    belongs_to  :topic, :counter_cache => true
    belongs_to  :user, :counter_cache => true

    after_create :update_topic_latest_post

    private

    def update_topic_latest_post
      self.topic.update_attribute(:latest_post_id, self.id)
    end
  end
end
