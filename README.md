# AWS OpsWorks PHP Simple Demo App

Directions on how to launch this sample app on AWS OpsWorks can be found in the article: [Walkthrough: Deploy a web
application and learn AWS OpsWorks basics](http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.phpapp.html).

# Modifications for myCloudWatcher

This demo has been modified to be more self-contained. The walkthrough linked to above requires writing custom
chef recipes. This demo has been modified to use the deploy-time hooks, specifically `before-migrate.rb`,
to set up the database and create connection information.

# Configuration

## Branch: version1

Version1 does not require any special configuraion. Simply deploy it and point your browser to the instance.

## Branch: version2

Version2 requires setting the following attributes in the Stack JSON:

    "deploy" : {
      "database" : {
        "host":     "mysql-host-name", # The name of the database host
        "username": "db-user",         # The user of the DB
        "password": "db-password",     # That user's password
        "database": "simple_php_demo"  # The name of the database
      }
    }
