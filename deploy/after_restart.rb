# after_restart.rb runs after the new application has been fetched and initialized by all prior hooks
# and downstream services have been restarted.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("after_restart.rb: node is #{node.inspect}")
