# before_restart.rb runs after the 'before_symlinks.rb hook, before downstream services
# (such as apache) are restarted.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_restart.rb is running.")

node[:deploy].each do |app_name, deploy_item|
  
  # In this example, the following code block directly executes a resource from
  # a public URL. Please, don't do this in your code. It's a gaping security hole.
  # Instead, consider creating a mirror of the public resource.
  script "install_composer for app #{app_name}" do
    interpreter "bash"
    user "root"
    cwd "#{deploy_item[:deploy_to]}/current"
    code <<-EOH
    curl -s https://getcomposer.org/installer | php
    php composer.phar install
    EOH
  end
  
  template "#{deploy_item[:deploy_to]}/current/db-connect.php" do
    source "demo-db-connect.php.erb"
    cookbook "mcw_deploy" # assumption: the mcw_deploy cookbook will be in the custom cookbook repo and available in this chef run
    mode 00660
    group deploy_item[:group]

    if platform?("ubuntu")
      owner "www-data"
    elsif platform?("amazon")   
      owner "apache"
    end

    variables(
      :host =>     (deploy_item[:database][:host] rescue nil),
      :user =>     (deploy_item[:database][:username] rescue nil),
      :password => (deploy_item[:database][:password] rescue nil),
      :db =>       (deploy_item[:database][:database] rescue nil),
      :table =>    (deploy_item[:database][:table] rescue nil)
    )

    only_if do
      ::File.directory?("#{deploy_item[:deploy_to]}/current")
    end
  end
  
end
