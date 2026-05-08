RSpec.configure do |config|
  config.before(:suite) do
    connection = ActiveRecord::Base.connection
    tables = connection.tables - %w[schema_migrations ar_internal_metadata]

    tables.each do |table|
      connection.execute("TRUNCATE TABLE #{connection.quote_table_name(table)} RESTART IDENTITY CASCADE")
    end
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
