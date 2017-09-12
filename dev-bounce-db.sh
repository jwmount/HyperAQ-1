#!/bin/bash
#
# drop and recreate the database, applying all of the migrations, load the database with seed data
#
bin/rails db:environment:set RAILS_ENV=development

rake db:drop 
rake db:create 
rake db:migrate 
rake db:seed

