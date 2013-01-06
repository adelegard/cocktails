# Cocktails

A website for sharing and exploring tasty cocktails.

## Getting up and running

### Step 1: Dependencies

Install all the necessary dependencies (xcode, homebrew, rvm, ruby, mysql). 
A decent tutorial on this is located here: http://www.frederico-araujo.com/2011/07/30/installing-rails-on-os-x-lion-with-homebrew-rvm-and-mysql/

### Step 2: Clone the git repo

```bash
git clone git@github.com:adelegard/cocktails.git some_folder_name
```

### Step 3: Grab all the necessary gems via bundler

```bash
bundle install
```

### Step 4: Create the cocktails database using MySql

```sql
create database cocktails
```

### Step 5: Populate the new database with the initial sql data

```bash
mysql -u root -p -h localhost cocktails_test2 < recipes_db_backup.sql
```
sql file located here (https://github.com/adelegard/cocktails/blob/master/db/backups/recipes_db_backup.sql)

### Step 6: Migrate the cocktails database to get it up to date

```bash
rake db:migrate
```

### Step 7: Start up the webserver

```bash
rvmsudo rails s -p 80 --debugger
```

### Step 8: Start up Thinking Sphinx

```bash
rake ts:start
```
If you haven't yet built up your Thinking Sphinx index, then first you'll need to run:  
```bash
rake ts:index
```
This will take 10-20 minutes.

### Step 9: Start up the Thinking Sphinx delayed job task

```bash
rake ts:dd
```
This keeps the Thinking Sphinx index in sync with the database (creating/updating/deleting).

## Contributing

### Step 1: Create a feature branch

```bash
git checkout -b branch_name
```

### Step 2: Write your code (and tests please)
### Step 3: Make your commits
### Step 4: Push to your branch's origin

```bash
git push -u origin branch_name
```

### Step 5: Create a [Pull Request][pull requests] from your branch
### Step 6: That's it!

[pull requests]: http://help.github.com/pull-requests/
