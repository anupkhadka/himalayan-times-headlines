require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    @headlines = scrap
    erb :index
  end

  private

  def scrap
    headlines = []
    html_doc = Nokogiri::HTML(open("https://thehimalayantimes.com/category/kathmandu/"))
    ul_main_news = html_doc.css("ul.mainNews")
    ul_main_news.each do |ul|
      lis = ul.css("li")
      lis.each do |li|
        headline = li.css("h3 a")
        if headline.empty?
          headline = li.css("h4 a")
        end
        if !headline.empty?
          headlines << headline.attribute("title").value
        end
      end
    end
    headlines
  end

end
