include_recipe '../cookbooks/hosts'

include_recipe '../cookbooks/postgresql'
include_recipe '../cookbooks/postgresql/directory_archivedir'
include_recipe '../cookbooks/postgresql/file_pgpass'
