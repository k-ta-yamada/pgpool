include_recipe '../cookbooks/hosts'

# TODO: need this?
include_recipe '../cookbooks/epel-release'

include_recipe '../cookbooks/postgresql'
include_recipe '../cookbooks/postgresql/initdb'
