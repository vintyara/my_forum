module MyForum
  module PostsHelper
    def format_post_text(post)
      format_bbcode(post.text)
    end

    def format_bbcode(text)
      # Line Breask
      text.gsub!(/\r\n/, '<br />')
      text.gsub!(/\n/, '<br />')

      # Images
      text.gsub!(/\[img\]/i,   '<img src="')
      text.gsub!(/\[\/img\]/i, '" />')

      # Youtube
      text.gsub!(/(?:https?:\/\/)?(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=)?(?<video_code>[\w-]{10,})/i) do |match|
        "<iframe width='560' height='315' src='https://www.youtube.com/embed/#{$~[:video_code]}' frameborder='0' allowfullscreen></iframe>"
      end

      # Attachments
      text.gsub!(/\[attachment=([0-9]+)\]/i) do |match|
        "<p> <img class='post_attachment' src='#{attachment_img_path($1)}' /> </p>"
      end

      # Bold text
      text.gsub!(/(\[b\](?<bold_text>.+?)\[\/b\])/i) { |match| "<strong>#{$1}</strong>" }

      # Italic
      text.gsub!(/(\[i\])(?<italic_text>.*?)(\[\/i\])/i) { |match| "<i>#{$1}</i>" }

      # Cut
      text.gsub!(/(\[cut\])(?<cut_text>.*?)(\[\/cut\])/i) { |match| "<pre>#{$1}</pre>" }

      # Color
      text.gsub!(/\[color=(.*?)\](.*?)\[\/color\]/i) { "<span style='color: #{$1}'>#{$2}</span>" }

      # Size
      text.gsub!(/\[size=(.*?)\](.*?)\[\/size\]/i) { "<span style='font-size: #{$1}'>#{$2}</span>" }

      # Quote
      #text.gsub!(/\[quote author=(.*?) link=(.*?) date=(.*?)\]/i) { bbquote(author: $1, date: $3) }
      #text.gsub!(/\[\/quote\]/i, '</div>')
      #text.gsub!(/\[quote(.*)\]/i, "<div class='bbqoute'>")
      text.gsub!(/\[quote author=(?<autor>.*)\](?<text>.*)\[\/quote\]/m) do |match|
        "<div class='bbqoute'> <div class='quote_info'>#{$~[:autor]} #{t('my_forum.bbquote.wrote')}:</div> #{$~[:text]} </div>"
      end

      text.gsub!(/(?<open>\[quote author=(?<autor>(.*?)) (.+)\](?<text>(.+))(?<close>\[\/quote\]))/i) do |match|
        # "<div class='bbqoute'> <div class='quote_info'>#{$~[:autor]} #{t('my_forum.bbquote.wrote')} #{Time.now}:</div> #{$~[:text]} </div>"
        "<div class='bbqoute'> <div class='quote_info'>#{$~[:autor]} #{t('my_forum.bbquote.wrote')}:</div> #{$~[:text]} </div>"
      end

      # Emoticons (smiles)
      emoticons_list.each do |code, path|
        text.gsub!(/#{Regexp.quote(code)}/) { "<img src='#{path}' class='smile' />" }
      end

      # Link
      text.gsub!(/\[url=(.*?)\](.*?)\[\/url\]/i)    { link_to($2, $1, target: '_blank') }
      text.gsub!(/(http:\/\/[\S]+|www:\/\/[\S]+)/i) { link_to($1, $1, target: '_blank') }

      text.html_safe
    end

    def bbquote(author:, date:)
      date_time = time(DateTime.strptime(date, '%s')) rescue ''
      "<div class='bbqoute'> <div class='quote_info'>#{author} #{t('my_forum.bbquote.wrote')} #{date_time}:</div> "
    end
  end
end
