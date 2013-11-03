# before_migrate.rb runs after the new application version is retrieved from the source repository.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_migrate.rb is running")

node[:deploy].each do |app_name, deploy_item|
  Chef::Log.debug("Looking at app #{app_name}")
  next unless deploy_item[:database]
  next unless deploy_item[:database][:host]
  next unless deploy_item[:database][:username]
  next unless deploy_item[:database][:password]
  next unless deploy_item[:database][:database]
  next unless deploy_item[:database][:table]
  
  execute "mysql-create-database #{deploy_item[:database][:database]}" do
    command "/usr/bin/mysql -h #{deploy_item[:database][:host]} -u #{deploy_item[:database][:username]} -p'#{deploy_item[:database][:password]}' -e 'CREATE DATABASE IF NOT EXISTS #{deploy_item[:database][:database]}'"
    not_if "/usr/bin/mysql -h #{deploy_item[:database][:host]} -u #{deploy_item[:database][:username]} -p'#{deploy_item[:database][:password]}' -e 'SHOW DATABASES' | fgrep #{deploy_item[:database][:database]}"
  end

  execute "mysql-create-table #{deploy_item[:database][:database]}" do
    command "/usr/bin/mysql -h #{deploy_item[:database][:host]} -u #{deploy_item[:database][:username]} -p'#{deploy_item[:database][:password]}' #{deploy_item[:database][:database]} -e 'CREATE TABLE #{deploy_item[:database][:table]}(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    author VARCHAR(63) NOT NULL,
    message TEXT,
    PRIMARY KEY (id)
  )'"
    not_if "/usr/bin/mysql -h #{deploy_item[:database][:host]} -u #{deploy_item[:database][:username]} -p'#{deploy_item[:database][:password]}' #{deploy_item[:database][:database]} -e 'SHOW TABLES' | grep #{deploy_item[:database][:table]}"
  end

end
