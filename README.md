## BookMark Manager

You can see the deployed app in this [link](http://byverdu-bookmark.herokuapp.com/)

A bookmark manager is a website to maintain a collection of links, organised by tags. You can use it to save a webpage you found useful. You can add tags to the webpages you saved to find them later. You can browse links other users have added.

The website will have the following options:

- Show a list of links from the database
- Add new links
- Add tags to the links
- Filter links by a tag

### How to run the tests

```ruby
> clone https://github.com/byverdu/BookMark_manager.git
> cd BookMark_manager

# Install all dependencies:
> bundle install

# Create a local database:
> psql
  =# CREATE DATABASE bookmark_manager_test;
  =# \q

# Run the auto-upgrade task:
> rake auto_upgrade
> rspec -fd
```

### Technologies used 

1. Ruby
2. Sinatra
1. RSpec
2. Capybara
1. SQL
1. SASS
1. HTML 
1. CSS
