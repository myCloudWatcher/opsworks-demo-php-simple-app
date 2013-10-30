# before_migrate.rb runs after the new application version is retrieved from the source repository.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_migrate.rb is running")

node[:deploy].each do |app_name, deploy|
  Chef::Log.debug("Looking at app #{app_name}")
  next unless deploy[:database]
  
  Chef::Log.debug("execute mysql-create-database... resource declaring now.")
  
  execute "mysql-create-database in database #{deploy[:database][:database]}" do
    command "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} -e'CREATE DATABASE IF NOT EXISTS #{deploy[:database][:database]}'"
    not_if "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} -e'SHOW DATABASES' | grep #{deploy[:database][:database]}"
  end

  execute "mysql-create-table in database #{deploy[:database][:database]}" do
    command "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} -e'CREATE TABLE #{deploy[:database][:table]}(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    author VARCHAR(63) NOT NULL,
    message TEXT,
    PRIMARY KEY (id)
  )'"
    not_if "/usr/bin/mysql -u#{deploy[:database][:username]} -p#{deploy[:database][:password]} #{deploy[:database][:database]} -e'SHOW TABLES' | grep #{deploy[:database][:table]}"
  end

  # In this example, the following code block directly executes a resource from
  # a public URL. Please, don't do this in your code. It's a gaping security hole.
  # Instead, consider creating a mirror of the public resource.
  script "install_composer for app #{app_name}" do
    interpreter "bash"
    user "root"
    cwd "#{deploy[:deploy_to]}/current"
    code <<-EOH
    curl -s https://getcomposer.org/installer | php
    php composer.phar install
    EOH
  end
  
  template "#{deploy[:deploy_to]}/current/db-connect.php" do
    source "db-connect.php.erb"
    cookbook "mcw_deploy" # assumption: this cookbook will be in the custom cookbook repo
    mode 0660
    group deploy[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    variables(
      :host =>     (deploy[:database][:host] rescue nil),
      :user =>     (deploy[:database][:username] rescue nil),
      :password => (deploy[:database][:password] rescue nil),
      :db =>       (deploy[:database][:database] rescue nil),
      :table =>    (deploy[:database][:table] rescue nil)
    )

   only_if do
     File.directory?("#{deploy[:deploy_to]}/current")
   end
  end
end
