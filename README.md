# volt-tutorial

### About

This is a tutorial for the Volt Ruby web-framework, http://www.voltframework.com 

And is divided into:

Initial setup and deployment
 - Dev environment, Linking to github with desktop app
 - Deployment on AWS/Heroku, Discussion of safari glitch with heroku-volt deployment
 - Using cloud mongo (compose.io) or local mongo database

Building the app
 - General use of Volt framework
 - Adding Ratchet mobile css framework to volt

#Initial setup and deployment
### Dev Environment (for macbook, window and linux will differ) and Initial App Creation

Note: $ at start indicates a system command on either dev machine or server

Install rvm (Ruby version manager)

    $ \curl -sSL https://get.rvm.io | bash -s stable

Install ruby 2.2.2 using rvm

    $ rvm install 2.2.2
    $ rvm use 2.2.2 --default
    $ ruby -v

Install volt gem to system

    $ gem install volt

Create a new app

    $ volt new volt-tutorial

To run your app

    $ cd volt-tutorial
    $ bundle exec volt server

You should see the following in the terminal (before installing mongo)

![](terminal_startup.png)

And if you go to localhost:3000 in your browser you should see

![](localhost.png)

Create a new git repo

    $ git init

Add new files and any changes to known files (later done automatically by github desktop app, can use checkboxes to disable tracking on file, or add to .gitignore manually)

    $ git add -A

Commit changes using command line (later done with commit button in github desktop app)

    $ git commit -m "Initial code repository"

### How to link to github with desktop app

Sign in to your github account from the "Github Desktop" menu, then click "Preferences"

![](github_add_account.png)


Click the plus sign to add a new repo, then navigate to the folder that you created the git repository, then click "open" and then "Create & Add Repository".  At this point the Github desktop app can track and add changes to your repo locally, and the repo can be published to Github by pressing the "Publish" button in upper right (button later becomes sync button), and then "Publish Repository"

![](github_add_repo.png)

### Setup cloud mongo database

Login to compose.io, create database (within deployment if not already created)

Create database user and password

Get the database URI, which will later set to environment variable

[insert walk through pictures, show where get the URI]

### How to link to Heroku

Specify ruby version in gemfile

    ruby "2.2.2" # specify a Ruby version

Add a Procfile that uses Thin

    web: bundle exec thin start -p $PORT -e $RACK_ENV

You will have to edit your config/app.rb file to look for the COMPOSEIO_URI environment variable.  This way when no environment variable is present you will default to the local mongo database. 

    config.db_driver = 'mongo'
    config.db_name = (config.app_name + '_' + Volt.env.to_s)

    if ENV['COMPOSEIO_URI'].present?
      config.db_uri = ENV['COMPOSEIO_URI'] # you will have to set this on heroku
    else
      config.db_host = 'localhost'
      config.db_port = 27017
    end

After creating new app, enter the git remote command located on the Deploy tab of your App instance (note: your app url will become http://{ app_name }.herokuapp.com )

    $ heroku git:remote -a volt-tutorial

View of heroku dashboard of app instance immeadiately after creating app

![](heroku_dashboard.png)

Set heroku environment variable for database server URI (uniform resource identifier)

    $ heroku config:set COMPOSEIO_URI="mongodb://db-user:db-password@candidate.52.mongolayer.com:10585/volt-tutorial"

Set local environment variable.  If you wanted to use the cloud database locally use export system command in same terminal window before runing the start volt server command

    $ export COMPOSEIO_URI="mongodb://db-user:db-password@candidate.52.mongolayer.com:10585/volt-tutorial" 

### Discussion of safari glitch with heroku-volt deployment

Heroku will work fine for simple Volt apps, but there appears to be a safari glitch that was also a glitch with the herokuish library if you try to deploy with dokku.  If you need to continously keep loading a large amount of new promises/models Safari will eventually stop updating the browser.  The only work around I am aware of is to deploy on AWS.

### Git push

Push changes using terminal to github after linked (can just press sync on desktop app)

    $ git push

Push changes to heroku

    $ git push heroku master

### Sublime text editor(other editors: atom, textmate) 

Open sublime text editor

    $ subl .

How to set subl to bash profile etc: 

    $ vi ~/.bashrc

Paste in 

    alias subl='~/Applications/Sublime\ Text\ 2/sublime_text'

Save and exit vi by typing

    :wq

and pressing enter

### Local Mongo database

Install using homebrew

    $ brew update
    $ brew install mongodb

Create mongo db data folder (preceding '/' indicates system root path, sudo will require admin password)

    $ sudo mkdir -p /data/db

Run mongodb server from any location

    $ sudo mongo


### Comment on Environment Variables

I recommend adding the text with the real username and password

    COMPOSEIO_URI="mongodb://db-user:db-password@candidate.52.mongolayer.com:10585/volt-tutorial" 

to a .env file in the root of your project dir (strictly for bookkeeping purposes) and also add .env to your project's .gitignore file.  There is the dotenv ruby gem that will automatically load these environment variables, its not necessary to use this for just a few variables.  Its good practice to never ever commit these passwords to the git repo, once you do that its considered no good.  



### AWS deployment

[insert: how to generate pem file and new server, also set custom tcp rule to allow connections to port 1234]

Set permissions on pem file

    $ chmod 400 my-key-pair.pem


SSH to AWS server in same folder as the pem file

    $ SSH -i my-key-pair.pem ubuntu@ec2-12-345-67-890.compute-1.amazonaws.com

Install new Ruby on Ubuntu, first install dependencies for rvm

    $ sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
    $ curl -L https://get.rvm.io | bash -s stable
    $ source ~/.rvm/scripts/rvm
    $ rvm install 2.2.2
    $ rvm use 2.2.2 --default
    $ ruby -v

Install newest bundler 

    $ gem install bundler --pre
 
Install dependency for nokogiri (Ruby dependency that is known to require extra steps/cause errors)

    $ sudo apt-get install ruby-dev zlib1g-dev

Copy app to local volt-tutorial-aws folder without .git folder, then copy to AWS server with scp command

    $ scp -i my-key-pair.pem -r volt-tutorial-aws ubuntu@ec2-12-345-67-890.compute-1.amazonaws.com:/home/ubuntu

NOTE: If redeploying, before running this scp command, SSH to server and delete the -aws folder

    $ rm -rf volt-tutorial-aws

NOTE: Also when redeploying you will need to restart the server, which is an easy way to kill the previously running process

![](aws_reboot_server.png)

SSH back to server, go to folder, install gems.

Run volt server with desired port, no hangouts, and saving terminal output to file

    $ cd volt-tutorial-aws
    $ bundle install
    $ nohup bundle exec volt server -p 1234 > allout.txt 2>&1 &

You can set the environment variable for the cloud database with following command, or install mongo to the server in next section

    $ export COMPOSEIO_URI="mongodb://db-user:db-password@candidate.52.mongolayer.com:10585/volt-tutorial"

Also can set the Sendgrid password with command (volt setup in later section)

    $ export SENDGRID_PASSWORD='12345678'

### Install mongo to AWS server using ubuntu 14

    $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    $ echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
    $ sudo apt-get update
    $ sudo apt-get install -y mongodb-org

It should automatically start, might require server restart, or just run 

    $ sudo service mongod start


### Install mailer

Add the following to config/app.rb, your SMTP username and password is the same username and password you provided when you signed up for SendGrid

    config.mailer.via = :smtp
    config.mailer.via_options = {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'myapp.com',
      :user_name => 'maxplomer-gramercytech',
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
    }

Add the following to app/main/views/mailer/test.email

    <:Subject>
      Welcome

    <:Html>
      <h1>Welcome </h1>

    <:Text>
      Welcome

You can now send an email by from the volt console with 

    Mailer.deliver('mailer/test', {to: 'max.plomer@gramercytech.com'})

You can create a task to send the test email and link to a button on homepage, in app/main/tasks/mailer_test_tasks.rb

    class MailerTestTasks < Volt::Task
      def send_test_email
        Mailer.deliver('mailer/test', {to: 'max.plomer@gramercytech.com'})
      end
    end 

Add button to your app/main/views/main/index.html file

    <button e-click="MailerTestTasks.send_test_email">send test email</button>


### Useful tips

**search previous commands**

Type CtrlR and then type part of the command you want. Bash will display the first matching command. Keep typing CtrlR and bash will cycle through previous matching commands.

**search folder, myfolder,  recursively for text, "search text"**

$ grep -r "search text" myfolder

### Reset password in Volt unfinished

I used the following to quickly get volt reset password to work, it is by no means the greatest solution, but it deals with Volt locking the ability to edit a User unless logged in, by just cloning the User and deleting the old.  Apparently there is a Volt.skip_permissions which looks to also get around this.  This feature may be finished in the current version of the gem, not sure if those changes have propagated everywhere though.

First download the gem manually https://github.com/voltrb/volt-user_templates and copy the app/user_templates folder to your project. Also remove volt-user_templates gem from your Gemfile, because we are now going to manually add it.

Replace app/user_templates/tasks/user_template_tasks.rb with

    require 'digest'

    class UserTemplateTasks < Volt::Task
      def send_reset_email(email)
        # Find user by e-mail
        Volt.skip_permissions do
          store._users.where(email: email).first.then do |user|
            if user
              reset_token = password_reset_token(user.id)

              reset_base_url = 'password_reset'

              reset_url = "http://#{Volt.config.domain}/#{reset_base_url}?user_id=#{user.id}&token=#{reset_token}"

              Mailer.deliver('user_templates/mailers/forgot',
                {to: email, name: user._name, reset_url: reset_url}
              )
            else
              raise "There is no account with the e-mail of #{email}."
            end
          end
        end
      end

      private
      def password_reset_token(user_id)
        Digest::SHA256.hexdigest("#{user_id}||#{Volt.config.app_secret}")
      end
    end

Replace app/user_templates/tasks/password_reset_tasks.rb with

    class PasswordResetTasks < Volt::Task
      def reset_password(user_id, token, new_password)
        store._users.where(id: user_id).first.then do |user|
          reset_token = password_reset_token(user.id)
          if token == reset_token

            name = user.name
            email = user.email
            user.destroy

            new_user = User.new(name: name, email: email, password: new_password)

            store._users << new_user

            new_user.hash_password
            
          end
        end
      end


      private
      def password_reset_token(user_id)
        Digest::SHA256.hexdigest("#{user_id}||#{Volt.config.app_secret}")
      end
    end

Replace app/user_templates/controllers/password_reset_controller.rb with

    module UserTemplates
      class PasswordResetController < Volt::ModelController
        reactive_accessor :new_password

        def reset_password
          query_params = url.query.split('&')
          user_id = query_params[0].split('=')[1]
          token = query_params[1].split('=')[1]

          PasswordResetTasks.reset_password(user_id, token, page._new_password)

          flash._successes << "Your password has been reset"
          redirect_to '/'
        end

      end
    end    

#Building the app

###Initial todo app

Add to User model

    has_many :projects

Create Project model

    $ volt generate model Project

Add to Project model

    has_many :tasks

Create Task model

    $ volt generate model Task


    




