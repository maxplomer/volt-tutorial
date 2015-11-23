# volt-tutorial

### About

This is a tutorial for the Volt Ruby web-framework, http://www.voltframework.com 

Covering:
 - general use, github, dev environment
 - deployment on aws/heroku, discussion of safari glitch with heroku-volt deployment
 - adding Ratchet mobile css framework to volt
 - Using cloud mongo (compose.io) or local mongo database




### Dev Environment (your laptop):

Note: $ at start indicates a system command on either dev machine or server

Install rvm (Ruby version manager)

    $ \curl -sSL https://get.rvm.io | bash -s stable

Install ruby 2.2.2 using rvm

    $ rvm install 2.2.2
    $ rvm use 2.2.2 --default
    $ ruby -v

Install volt gem to system

    $ gem install volt

Create a new app:

    $ volt new volt-tutorial

To run your app: 

    $ cd volt-tutorial
    $ bundle exec volt server

You should see the following in the terminal (before installing mongo)

![](terminal_startup.png)

And if you go to localhost:3000 in your browser you should see

![](localhost.png)

Create a new git repo:

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



### Git push

Push changes using terminal to github after linked (can just press sync on desktop app)

    $ git push

Push changes to heroku

    $ git push heroku master

### Sublime text editor(other editors: atom, textmate) 

Open sublime text editor

    $ subl .

how to set subl to bash profile etc: 

    $ vi ~/.bashrc

paste in 

    alias subl='~/Applications/Sublime\ Text\ 2/sublime_text'

save and exit vi by typing

    :wq

and pressing enter

### Local Mongo database

**setup local mongo database**

Install using homebrew

    $ brew update
    $ brew install mongodb

Create mongo db data folder (preceding '/' indicates system root path, sudo will require admin password)

    $ sudo mkdir -p /data/db

Run mongodb server from any location

    $ sudo mongo


### Comment on Environment Variables

I recommend adding the text

    COMPOSEIO_URI="mongodb://db-user:db-password@candidate.52.mongolayer.com:10585/volt-tutorial" 

to a .env file in the root of your project dir (strictly for bookkeeping purposes) and also add .env to your project's .gitignore file.  There is the dotenv ruby gem that will automatically load these environment variables, its not necessary to use this for just a few variables.  Its good practice to never ever commit these passwords to the git repo, once you do that its considered no good.  



### AWS deployment

[insert: how to generate pem file and new server, also set custom tcp rule to allow connections to port 1234]

Set permissions on pem file

    $ chmod 400 my-key-pair.pem


ssh to AWS server

    $ ssh -i my-key-pair.pem ubuntu@ec2-12-345-67-890.compute-1.amazonaws.com

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

Copy app to local volt-tutorial-aws folder without .git folder, then copy to aws server with scp command

    $ scp -i my-key-pair.pem -r volt-tutorial-aws ubuntu@ec2-12-345-67-890.compute-1.amazonaws.com:/home/ubuntu

NOTE: If redeploying, before running this scp command, ssh to server and delete the -aws folder

    $ rm -rf volt-tutorial-aws

ssh back to server, install gems, run volt server with desired port no hangouts

    $ cd volt-tutorial-aws
    $ bundle install
    $ nohup bundle exec volt server -p 1234 &

You can set the environment variable for the cloud database with following command, or install mongo to the server in next section

    $ export COMPOSEIO_URI="mongodb://db-user:db-password@candidate.52.mongolayer.com:10585/volt-tutorial"


### install mongo to aws server using ubuntu 14

    $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    $ echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
    $ sudo apt-get update
    $ sudo apt-get install -y mongodb-org

It should automatically start, might require server restart, or just run 

    $ sudo service mongod start




### installing open sans font


### useful tips

**search previous commands**

Type CtrlR and then type part of the command you want. Bash will display the first matching command. Keep typing CtrlR and bash will cycle through previous matching commands.

**search folder, myfolder,  recursively for text, "search text"**

$ grep -r "search text" myfolder
