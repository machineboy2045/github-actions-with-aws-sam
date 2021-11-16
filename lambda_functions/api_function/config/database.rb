# frozen_string_literal: true

class Database
  attr_reader :client, :stage

  def initialize(stage)
    raise 'stage is required' unless stage

    @stage = stage
    @client = init_client
    configure_tables
  end

  def clear
    raise 'Only use this in test stage!' unless stage == ENVS[:test]

    Aws::Record::TableMigration.new(User, client: client).delete!
  rescue Aws::Record::Errors::TableDoesNotExist
    false
  end

  def migrate
    raise 'Only use this in test stage!' unless stage == ENVS[:test]

    migration = Aws::Record::TableMigration.new(User, client: client)
    migration.create!(
      provisioned_throughput: {
        read_capacity_units: 5,
        write_capacity_units: 5
      }
    )
    migration.wait_until_available
  end

  private

  def init_client
    if stage == ENVS[:test]
      puts 'Using test DB'
      Aws::DynamoDB::Client.new(
        region: 'local',
        endpoint: 'http://localhost:8001',
        access_key_id: 'anykey-or-xxx',
        secret_access_key: 'anykey-or-xxx'
      )
    else
      Aws::DynamoDB::Client.new
    end
  end

  def configure_tables
    puts "Using table #{USERS_TABLE_NAME}"
    User.configure_client(client: client)
    User.set_table_name(USERS_TABLE_NAME)
  end
end
