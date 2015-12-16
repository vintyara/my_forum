require_dependency "my_forum/application_controller"

module MyForum
  class WelcomeController < ApplicationController
    def index
      @forum_categories = if current_user && current_user.is_admin?
                            Category.includes(:forums)
                          else
                            @forum_categories = Category.includes(:forums, :user_groups).
                              reject{|category| (category.user_groups.map(&:name) & (current_user_groups)).blank? }
                          end


      # Don`r forget permissions
      available_forum_ids = MyForum::Forum.where(category_id: @forum_categories.map(&:id)).pluck(:id)
      @recent_topics = if available_forum_ids.blank?
                        []
                      else
                        Topic.find_by_sql("
                          SELECT my_forum_topics.* FROM my_forum_topics
                          JOIN my_forum_forums ON my_forum_forums.id = my_forum_topics.forum_id
                          WHERE my_forum_forums.id IN (#{available_forum_ids.join(',')})
                          ORDER BY my_forum_topics.updated_at DESC limit 10
                        ")
                      end

    end
  end
end
