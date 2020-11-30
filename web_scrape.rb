require 'rest-client'

def fetch_news
  response = RestClient.get 'https://time.com/'
  response.body
end

news = fetch_news
# body.gsub!(/\n\s+/, " ")

# Latest stories section
latest_stories_section_regex = /<section class="homepage-module latest" data-module_name="Latest Stories">((.|\n)*?)<\/section>/
latest_stories_section = news.match(latest_stories_section_regex)[0]

# Stories
stories_regex = /<li>((.|\n)*?)<\/li>/
stories = latest_stories_section.scan(stories_regex).flatten
stories.reject! { |e| e == " " }
stories.map! { |e| e.strip }

stories_list = []

story_href_regex = /href=((.)*)\/>/
story_title_regex = /\/>((.)*)<\/a>/
stories.each do |story, stories_hash={} |
  stories_hash[:title] = story.match(story_title_regex)[1]
  stories_hash[:href] = "https://time.com#{story.match(story_href_regex)[1]}"
  stories_list.push(stories_hash)
end

puts stories_list