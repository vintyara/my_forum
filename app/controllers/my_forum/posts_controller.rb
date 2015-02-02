require_dependency "my_forum/application_controller"

module MyForum
  class PostsController < ApplicationController
    before_filter :find_topic
    before_filter :find_forum

    def create
      post = @topic.posts.build(post_params)
      post.user = current_user
      post.save
      redirect_to forum_topic_path(@forum, @topic)
    end

    private

    def find_topic
      @topic = Topic.find(params[:topic_id])
    end

    def find_forum
      @forum = Forum.find(params[:forum_id])
    end

    def post_params
      params.require(:post).permit(:text)
    end
  end
end