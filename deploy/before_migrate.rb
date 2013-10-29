# before_migrate.rb runs after the new application version is retrieved from the source repository.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_migrate.rb: node is #{node.inspect}")
