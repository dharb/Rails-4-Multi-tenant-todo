# Rails 4 Multi-tenant Todo App

This is a basic multi-tenant RoR todo application. Application data is separated into different companies. Requests are routed by subdomains. Users can have private and public tasks--a user can see their own private tasks and all public tasks by users in their company. This API is set up to use token header authentication for users. When a user is created, they are assigned a unique token. Upon that user's session being destroyed, their token is erased. A new token is generated for them when they sign in again.

I wrote this as a code sample for TDD JSON API development.

Requires PostgreSQL, Rails 4.2 and Ruby 2.1 or higher.

## Usage

```
git clone https://github.com/dharb/todo.git
cd todo
gem install bundler
bundle
rake db:create
rake db:migrate
rake db:seed
# Run test suite
rake db:test:prepare
bundle exec rspec
```

And so on and so forth. To see all endpoints, run rake routes. For further info on endpoints and what they should return, take a look at the files in spec/controllers/api/v1. To test locally, after running the seed file, boot up rails console and find a user's auth token. Then fire up a rails server, and structure requests in the following format:

```
curl -H 'Accept: application/vnd.todo.v1' -H 'Authorization: :auth_token' \
http://subdomain.lvh.me:3000/tasks

curl -H "Accept: application/json" -H "Content-type: application/json" -H 'Accept: application/vnd.todo.v1' -H 'Authorization: :auth_token' -d '{"task":{"title":"new task"}}' http://subdomain.lvh.me:3000/users/:id/tasks

# where :auth_token is a user's authentication token, subdomain is the subdomain of that user's company, and :id is that user's id.
```
