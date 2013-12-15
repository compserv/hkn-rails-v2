## HKN Compserv - Rails App

### Setup

You will need Ruby 2.0.0 and Rails 4.0. Once you have both of those installed, you can run the following:

    bundle install

### Setting up your database

Make a copy of the sample database.yml file:

    cp config/sample/database.yml config/database.yml

Open it up and change the username for the development and test environments.

Next, you're going to have to create a file for storing development environment variables.

    touch config/initializers/environment_variables.rb

Don't worry, this file is not commmitted to git so you can add whatever keys you want to this file. It will remain active in devleopment mode only. Then run:

    rake db:migrate

And if that goes well too, you can start the rails server!

    rails s
