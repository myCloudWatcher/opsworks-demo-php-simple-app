# AWS OpsWorks PHP Demo App - "Share Your Thoughts"

Directions on how to launch this sample message board app on AWS OpsWorks can be found in **Step 2** of the article:
[Walkthrough: Deploy a web application and learn AWS OpsWorks basics](http://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted.walkthrough.phpapp.2.html).

This demo app is also featured in a video called [AWS OpsWorks Overview and Demo](http://www.youtube.com/watch?v=cj_LoG6C2xk) on YouTube.

# Modifications for myCloudWatcher

This demo has been modified to be more self-contained. The walkthrough linked to above requires writing custom
chef recipes. This demo has been modified to use the deploy-time hooks, specifically `before-migrate.rb`,
to set up the database and create connection information.

# Configuration

## Branch: version1

Version1 does not require any special configuraion. Simply deploy it and point your browser to the instance.

## Branch: version2

The document root of this branch is `web`. Set it in the OpsWorks app settings.

Set the following attributes in the Stack JSON, where `app-name` is the shortname
of the app:

    "deploy" : {
      "app-name" : {
        "database" : {
          "host":     "mysql-host-name", # The name of the database host
          "username": "db-user",         # The user of the DB
          "password": "db-password",     # That user's password
          "database": "simple_php_demo"  # The name of the database
        }
      }
    }
