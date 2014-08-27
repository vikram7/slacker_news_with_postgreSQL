Slacker News...But This Time With Databases!
Pair
Slacker News

I swear this is the last time we'll use this app in a challenge. But now you get to use your knowledge of relational databases to turn it into something a bit more interesting! Try re-implementing the following user stories using PostgreSQL rather than CSV files.

For an additional challenge, several user stories for commenting on articles have been included.

User Stories

As a slacker
I want to be able to submit an incredibly, interesting article
So that other slackers may benefit
Acceptance Criteria

I can visit /articles/new which displays a new article form
I can specify a title, url and description
When I successfully post an article, it should be saved to a database
As a slacker
I want to be able to visit a page that shows me all the submitted articles
So that I can slack off
Acceptance Criteria

When visiting /articles I should see all the articles that have been submitted
Each article should show it's description, and title, and url
If I click on the url it should take me to the relevant page inside of a new tab
Non-Core User Stories for Validation

As an errant slacker
I want to receive an error message
When I submit an invalid article
Acceptance Criteria

If I do not specify a title, url, and description, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
If I specify an invalid URL, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
If I specify a description that doesn't have 20 or more characters, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
The submitted article is not saved in any of the above cases.
As a plagarizing slacker
I want to receive an error message
When I submit an article that has already been submitted
Acceptance Criteria

If I specify a url that has already been submitted, I receive an error message, and the submission form is re-rendered with the details I have previously submitted.
The submitted article is not saved in the above case.
Non-Core User Stories for Comments

As a slacker
I want to waste time reading article comments
So that I don't have to waste time reading the actual article
Acceptance Criteria

The /articles page contains a link to the comments section of an article at /articles/:article_id/comments (e.g. /articles/2/comments will show all the comments for the article with an ID = 2).
Visiting /articles/:article_id/comments will show a list of comments and when they were created.
As an angry citizen of the Internet
I want to leave scathing comments on an article
So that the uneducated masses will be enlightened by my vast intellect
Visiting /articles/:article_id/comments includes a form for creating a new comment.
The form submits a POST request to /articles/:article_id/comments which will create a new comment for the given article.
If the form is missing the body of the comment, do not save the comment and display an error message on the form.
Hints

You'll have to create and manage the schema before you can read and write to the database. I'd recommend putting an Data Definition Language (DDL) statements in a file called schema.sql in the root of your application:

CREATE TABLE articles (
  id serial PRIMARY KEY,
  ...
);

CREATE TABLE comments (
  id serial PRIMARY KEY,
  ...
);
When you want to run the statements on your database, you can use psql:

$ createdb slacker_news
$ psql slacker_news < schema.sql
If you want to make changes to your schema, the easiest thing to do at this point is to re-create the database and re-run your DDL statements:

$ dropdb slacker_news
$ createdb slacker_news
$ psql slacker_news < schema.sql
Submission

Submit a GitHub repo with your Slacker news app below.

