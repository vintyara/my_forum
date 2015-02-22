module MyForum
  module ApplicationHelper

    def draw_navigation
      html_li  = content_tag :li, link_to('Forums', root_path)

      if @forum
        html_li += content_tag :li, '&rarr;'.html_safe
        html_li += content_tag :li, link_to(@forum.name, forum_path(@forum))
      end

      if @forum && @topic && !@topic.new_record?
        html_li += content_tag :li, '&rarr;'.html_safe
        html_li += content_tag :li, link_to(@topic.name.html_safe, forum_topic_path(@forum, @topic))
      end

      html = content_tag :ul, class: 'draw-navigation' do
        html_li
      end

      html.html_safe
    end

    def online_users
      User.online.pluck(:login).join(', ')
    end

    def errors_for(obj)
      return unless obj.errors

      content_tag :div, obj.errors.full_messages.to_sentence
    end

  end
end
