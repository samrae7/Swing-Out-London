module PageHelper

  # Switching h1 and h2 in the header
  def heading_hn(action, *args, &block)
    if action == "index" then
      hn = :h1
    else
      hn = :h2
    end
    
    content_tag hn, *args, &block
  end
  
  # Links for navigation
  def nav_link(name, options={}, html_options={})
    icon_class = html_options.delete(:icon_class)
    content = ""
    content += content_tag(:i, nil, :class => icon_class) if icon_class
    content += name
    
    # Render the link...
    link_to_unless_current(raw(content), options, html_options) do 
      # ...but if the page was current, render a span instead
      content_tag :span, raw(content), :class => "current"
    end 
  end
  
  def display_tweet(tweet)
    if tweet
      # tweet is a Hashie::Mash, so acts like an object
      created_date_string = tweet.created_at.to_s(:timepart) + " on " + tweet.created_at.to_s(:short_date)
  
      raw tweet.text.twitterify + " " + link_to(created_date_string, "#{TWITTER_URL}/status/#{tweet.id}", :class => "tweet_created")
    else
      raw "Sorry, for some reason we can't load the latest tweet. Please visit the " + 
        link_to("Swing Out London Twitter feed", "#{TWITTER_URL}", :title => "Swing Out London on Twitter")
    end
  end
end