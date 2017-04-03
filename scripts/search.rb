# Javascript helper to copy task for lvl 1-3
#
String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
#var element = $('.pull-request-avatar')[0], id = element? element.src.match(/(\d+)\./)[1] : 'nil', title = $('.pull-request-title').text(), comand = "search(agent, " + id+ ",\"" + title + "\")"; console.log(id); copy(comand); console.log(comand);
# var element = $('.pull-request-avatar')[0], id = element? element.src.match(/(\d+)\./)[1] : '', title = $('.pull-request-title').text(), comand = title.replace('"', '\\"'); copy(comand); console.log(comand);

require 'mechanize'
require 'json'
require 'csv'
agent = Mechanize.new

page = agent.get("https://github.com/login")
page.form.field_with(name: 'login').value = '#login'
page.form.field_with(name: 'password').value = '#passowrd'
page.form.submit

@data = Dir['rubyconf/*.csv'].flat_map{|x| CSV.read(x)};1

def user_name_by_id(agent, id)
  JSON.parse(agent.get("https://api.github.com/user/#{id}").body)['login']
end

def process_page(page, message)
  rows = page.parser.css(".issues-listing > ul > li:contains('#{message}')")

  if rows.count > 0
    p rows.count
    rows.each do |row|
      link = row.at('a.link-gray-dark.no-underline.h4')
      title = link.text.strip
      action = 'open' if !row.at('.open').nil?
      action = 'rejected' if !row.at('.closed').nil?
      action = 'merged' if !row.at('.merged').nil?

      p [title, action, href: "https://github.com" + link[:href]]
    end
  else
    p 'not found'
  end
end

def search(agent, user_id, message)
  user = user_name_by_id(agent, user_id)

  url = "https://github.com/pulls?q=is%3Apr+author%3A#{user}"

  page = agent.get(url)
  process_page(page, message)
  pages_count = page.at('.next_page')&.previous&.previous&.text&.to_i || 1

  2.upto(pages_count) do |page_number|
    page = agent.get("#{url}&page=#{page_number}")
    process_page(page, message)
  end
end

# LIST OF ALL repositories
popular = ['https://github.com/rspec/rspec-core/',
'https://github.com/capistrano/capistrano/',
'https://github.com/rack/rack/',
'https://github.com/RubyMoney/money',
'https://github.com/RubyMoney/monetize',
'https://github.com/RubyMoney/money-rails',
'https://github.com/RubyMoney/google_currency',
'https://github.com/sinatra/sinatra',
'https://github.com/rails/rails',
'https://github.com/rails/jbuilder',
'https://github.com/rails/sprockets',
'https://github.com/rails/arel',
'https://github.com/resque/resque/',
'https://github.com/rust-lang/rust/',
'https://github.com/puma/puma/',
'https://github.com/ankane/searchkick/',
'https://github.com/mperham/sidekiq/',
'https://github.com/teamcapybara/capybara/',
'https://github.com/carrierwaveuploader/carrierwave/',
'https://github.com/sparklemotion/nokogiri/',
'https://github.com/redis/redis-rb/',
'https://github.com/kaminari/kaminari',
'https://github.com/slim-template/slim',
'https://github.com/mislav/will_paginate/',
'https://github.com/rom-rb/rom/',
'https://github.com/macournoyer/thin/',
'https://github.com/haml/haml',
'https://github.com/CanCanCommunity/cancancan',
'https://github.com/rmagick/rmagick/',
'https://github.com/collectiveidea/delayed_job/']


# Scrape all PRs from repository
require 'csv'
popular = ['https://github.com/collectiveidea/delayed_job/']
popular.map{|x| x.split('/').last(2)}.each do |user, repo|
  p [user, repo]
  CSV.open("rubyconf/rubyconf-#{user}-#{repo}.csv", 'w+') do |csv|
    page_number = 1
    begin
      page = agent.get("https://api.github.com/repos/#{user}/#{repo}/pulls?state=all&per_page=100&page=#{page_number}")
      data = JSON.parse(page.body)
      data.each do |pull|
        csv << [user, repo, pull['number'], pull['title'], pull['closed_at'], pull['merged_at'], pull['user']['login'], pull['user']['id'], pull['user']['avatar_url']]
      end
      page_number +=1
    end while page.header['link'] =~ /next/
  end
end

