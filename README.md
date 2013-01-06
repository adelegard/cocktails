# Cocktails

A website for sharing and exploring tasty cocktails.

## Getting up and running

1. Install all the necessary dependencies (xcode, homebrew, rvm, ruby, mysql). 
A decent tutorial on this is located here: http://www.frederico-araujo.com/2011/07/30/installing-rails-on-os-x-lion-with-homebrew-rvm-and-mysql/
2. Clone the git repo

```
    git clone git@github.com:adelegard/cocktails.git some_folder_name
```
3. Grab all the necessary gems via bundler

```
    bundle install
```
4. Create the cocktails database using MySql

``` sql
    create database cocktails
```
5. Populate the new database with the initial sql data

```
    mysql -u root -p -h localhost cocktails_test2 < recipes_db_backup.sql
```

sql file located here (https://github.com/adelegard/cocktails/blob/master/db/backups/recipes_db_backup.sql)
6. Migrate the cocktails database to get it up to date

```
    rake db:migrate
```
7. Start up the webserver

```
    rvmsudo rails s -p 80 --debugger
```
8. Start up Thinking Sphinx

```
    rake ts:start
```
If you haven't yet built up your Thinking Sphinx index, then first you'll need to run:

```
    rake ts:index
```
This will take 10-20 minutes.
9. Start up the Thinking Sphinx delayed job task

```
    rake ts:dd
```
This keeps the Thinking Sphinx index in sync with the database (creating/updating/deleting).

## Contributing

1. Create a feature branch

```
    git checkout -b branch_name
```
3. Write your code (and tests please)
4. Make your commits
5. Push to your branch's origin
```
    git push -u origin branch_name
```
5. Create a [Pull Request][pull requests] from your branch
6. That's it!

[pull requests]: http://help.github.com/pull-requests/
