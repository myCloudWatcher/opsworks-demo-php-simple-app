# before_migrate.rb runs after the new application version is retrieved from the source repository.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_migrate.rb is running")

node[:deploy].each do |app_name, deploy|
  Chef::Log.debug("Looking at app #{app_name}")
  next unless deploy[:database]
  
  execute "mysql-create-database #{deploy[:database][:database]}" do
    command "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p'#{deploy[:database][:password]}' -e 'CREATE DATABASE IF NOT EXISTS #{deploy[:database][:database]}'"
    not_if "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p'#{deploy[:database][:password]}' -e 'SHOW DATABASES' | fgrep #{deploy[:database][:database]}"
  end

  execute "mysql-create-table #{deploy[:database][:database]}" do
    command "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p'#{deploy[:database][:password]}' #{deploy[:database][:database]} -e 'CREATE TABLE #{deploy[:database][:table]}(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    author VARCHAR(63) NOT NULL,
    message TEXT,
    PRIMARY KEY (id)
  )'"
    not_if "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} -p'#{deploy[:database][:password]}' #{deploy[:database][:database]} -e 'SHOW TABLES' | grep #{deploy[:database][:table]}"
  end

end
