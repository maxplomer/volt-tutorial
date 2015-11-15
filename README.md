# volt-tutorial

## About

This is a tutorial for the Volt Ruby web-framework, http://www.voltframework.com 

Covering:
 - general use
 - deployment on aws/heroku, discussion of safari glitch with heroku-volt deployment
 - adding Ratchet mobile css framework to volt
 - Using cloud mongo (compose.io) or local mongo database




## Dev Environment (your laptop):

Install rvm (Ruby version manager)

    \curl -sSL https://get.rvm.io | bash -s stable

Install ruby 2.2.2 using rvm

    rvm install 2.2.2
    rvm use 2.2.2 --default
    ruby -v




Create a new app:

    $ volt new volt-tutorial



To run your app: 

    cd volt-tutorial
    bundle exec volt server

Create a new git repo:

    git init

Add new files and any changes to known files

    git add -A

Commit changes

    git commit -m "Initial code repository"

[explain how to link to github with desktop app]

Push changes using terminal to github after linked (can just press sync on desktop app)

    git push

Push changes to heroku

    git push heroku master


Open sublime text editor(other editors: atom, textmate) 

    subl .

[explain how to set subl to bash profile etc]
