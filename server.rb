require 'sinatra'
require 'csv'
require 'pry'
require 'uri'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')
    yield(connection)
  ensure
    connection.close
  end
end

def get_article_data

sql = "SELECT id, description, title, url FROM articles"

  @articles = db_connection do |db|
    db.exec(sql)
  end

  @articles.to_a

end

def bad_title_or_url(title_string,url_string,description_string)
  out = false
  out = (url_string != /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/.match(url_string).to_s) || (title_string == "") || (url_string == "") || description_string.length < 20
  return out
end

def check_if_url_already_exists(string)
  sql = "SELECT url FROM articles WHERE url = $1"
  out = db_connection do |db|
    db.exec(sql,[string])
  end
  binding.pry
  if out.to_a.uniq[0]["url"] == string
    return true
  else
    false
  end
end

def new_comment(article_id_in, text_in)
  sql = "INSERT INTO comments (article_id, text) VALUES ($1, $2)"
    db_connection do |db|
      db.exec(sql,[article_id_in,text_in])
    end
end

get '/' do

  @articles = get_article_data

  erb :index
end

get '/articles' do

  @articles = get_article_data

  erb :index

end

get '/articles/new' do

  erb :submit
end

get '/error_page' do

  erb :error_page
end

get '/url_already_exists' do
  erb :url_already_exists
end

post '/articles/new' do

  title = params["title"]
  url = params["url"]
  url_no_prefix = url.gsub(/(http\:\/\/)|(https\:\/\/)/, "")
  description = params["description"]

  if bad_title_or_url(title,url,description)
    redirect '/error_page'
  elsif check_if_url_already_exists(url_no_prefix)
    redirect '/url_already_exists'
  else
   sql = "INSERT INTO articles (title, url, description) VALUES ($1, $2, $3)"
    db_connection do |db|
      db.exec(sql, [title, url_no_prefix, description])
    end

      redirect '/'
  end
end


get '/articles/:article_id/comments' do

  @articles = get_article_data
  @article_id = params["article_id"].to_i

  sql = "SELECT id, description, title, url FROM articles where id = $1"

  output = db_connection do |db|
    db.exec(sql, [@article_id])
  end

  output = output.to_a[0]

  @title = output["title"]
  @description = output["description"]
  @url = output["url"]


  sql = "SELECT * FROM comments
  JOIN articles ON articles.id = comments.article_id"

  @select_data = db_connection do |db|
    db.exec(sql)
  end

  erb :comments
end

post '/articles/:article_id/comments' do

  @article_id = params["article_id"]
  @text = params["text"]

  new_comment(@article_id, @text)


  redirect '/'

end
