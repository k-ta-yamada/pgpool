DATABASE_USERS = node[:postgresql][:database_users]

execute "ALTER ROLE #{DATABASE_USERS[:recovery_user]} WITH PASSWORD" do
  user 'postgres'
  command %(psql -c "ALTER ROLE #{DATABASE_USERS[:recovery_user]} WITH PASSWORD '#{DATABASE_USERS[:recovery_password]}'")
end

execute "DROP ROLE #{DATABASE_USERS[:replication_user]}" do
  user 'postgres'
  command %(psql -c "DROP ROLE IF EXISTS #{DATABASE_USERS[:replication_user]}")
end
execute "CREATE ROLE #{DATABASE_USERS[:replication_user]}" do
  user 'postgres'
  command %(psql -c "CREATE ROLE #{DATABASE_USERS[:replication_user]} LOGIN REPLICATION PASSWORD '#{DATABASE_USERS[:replication_password]}'")
end

execute "DROP ROLE #{DATABASE_USERS[:xxx_check_user]}" do
  user 'postgres'
  command %(psql -c "DROP ROLE IF EXISTS #{DATABASE_USERS[:xxx_check_user]}")
end
execute "CREATE ROLE #{DATABASE_USERS[:xxx_check_user]}" do
  user 'postgres'
  command %(psql -c "CREATE ROLE #{DATABASE_USERS[:xxx_check_user]} LOGIN REPLICATION PASSWORD '#{DATABASE_USERS[:xxx_check_password]}'")
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
