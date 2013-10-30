# before_restart.rb runs after the 'before_symlinks.rb hook, before downstream services
# (such as apache) are restarted.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_restart.rb is running.")
