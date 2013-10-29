# Deploy hooks

This directory contains ruby scripts that are called during the Chef "deploy" run.
For detailed information see the [OpsCode `deploy` documentation][1].

`before_migrate.rb` is called after the new code is retrieved from the source code repository.

`before_symlink.rb` is called after that, before shared symlinks are created.

`before_restart.rb` is called after that, before downstream services (such as apache) are restarted.

`after_restart.rb` is called last, after downstream services have restarted.

[1]: http://docs.opscode.com/resource_deploy.html#DeployResource-Discussion
