# README
# Quizathon

## Requirements
* Ruby 3.1.2
* Rails 7.0.4
* Postgresql 1.1

## Getting Started
* Clone the repository
git clone https://github.com/agarwalrashika00/quizathon.git

* * Copy the following files to /config folder having appropriate api keys and/or credentials
```
 database.yml.example      => database.yml
 ```
* Install required gems
```
 bundle install
```

* Create database
```
 bundle exec rake db:create
```

* Run migrations
```
 bundle exec rake db:migrate
```
## Rails Server
* Start rails server
bundle exec rails server

## To visit user
* Go to http://localhost:3000

## sign up for user
* Go to http://localhost:3000/sign_up

## sign in for user
* Go to http://localhost:3000/sign_in

## To visit admin end
* Go to http://localhost:3000/admin

## sign in for admin
* Go to http://localhost:3000/admin/sign_in

## view all users for admin
* Go to http://localhost:3000/admin/users
