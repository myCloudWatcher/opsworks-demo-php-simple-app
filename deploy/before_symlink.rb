# before_symlink.rb runs after the "before_migrate" hook.
# This file is a ruby script, run in the context of a chef 'deploy' action.
# It can access all resources available to the Chef recipe.

Chef::Log.debug("before_symlink is running.")
