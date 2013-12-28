## HKN Compserv - Rails App

### Setup

You will need Ruby 2.0.0 and Rails 4.0. Once you have both of those installed, you can run the following:

    bundle install

If you do not yet have it installed and configured, you will also need postgresql.

#### Extra Instuctions for Ubuntu

Run the following:

    sudo apt-get install postgresql

If you want to login as yourself, do

    sudo -u postgres createuser [login]

Set up the postgres account password with

    sudo -u postgres psql postgres

At the prompt, run

    \password postgres

If you have created an account for yourself, also run

    \password [login]

to set your own password.

### Setting up your database

Make a copy of the sample database.yml file:

    cp config/sample/database.yml config/database.yml

Open it up and change the username for the development and test environments. 

Next, you're going to have to create a file for storing development environment variables.

    touch config/initializers/environment_variables.rb

Now, create the database by running:

    createdb hkn_rails_development

If you're running Ubuntu and it doesn't work under your login, you can try it under the postgres login:

    sudo -u postgres createdb hkn_rails_development

Don't worry, this file is not commmitted to git so you can add whatever keys you want to this file. It will remain active in devleopment mode only. Then run:

    rake db:migrate

You also may need to run the following if you're on Ubuntu:

    rake db:migrate RAILS_ENV=development

And if that goes well too, you can start the rails server!

    rails s

### Running Tests

To run all the tests, simply run:

    rspec .

To run a specific test, just run:

    rspec path/to/spec/file.rb

You may need to set up your test database, to do so, run:

    createdb hkn_rails_test

Then run the migrations:

    rake db:migrate RAILS_ENV=test
