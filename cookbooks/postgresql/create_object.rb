execute 'ALTER ROLE postgres WITH PASSWORD' do
  user 'postgres'
  command %(psql -c "ALTER ROLE postgres WITH PASSWORD 'postgres'")
end

# TODO: get user_name from xxx.yml
execute 'DROP ROLE repl' do
  user 'postgres'
  command %(psql -c "DROP ROLE IF EXISTS repl")
end
# TODO: get user_name from xxx.yml
execute 'CREATE ROLE repl' do
  user 'postgres'
  command %(psql -c "CREATE ROLE repl LOGIN REPLICATION PASSWORD 'repl'")
end

# TODO: get user_name from xxx.yml
execute 'DROP ROLE repl' do
  user 'postgres'
  command %(psql -c "DROP ROLE IF EXISTS pgpool")
end
# TODO: get user_name from xxx.yml
execute 'CREATE ROLE pgpool' do
  user 'postgres'
  command %(psql -c "CREATE ROLE pgpool LOGIN PASSWORD 'pgpool'")
end

# MEMO: Dependent package: pgpool-II-96-extensions
execute 'DROP EXTENSION pgpool_recovery' do
  user 'postgres'
  command %(psql -d template1 -c "DROP EXTENSION IF EXISTS pgpool_recovery")
end
execute 'CREATE EXTENSION pgpool_recovery' do
  user 'postgres'
  command %(psql -d template1 -c "CREATE EXTENSION pgpool_recovery")
end
