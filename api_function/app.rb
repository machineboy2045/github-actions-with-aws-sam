# frozen_string_literal: true

require 'json'
require 'aws-record'
require 'securerandom'
require_relative 'config/database'
require_relative 'models/user'
require_relative 'lib/utils'

PROJECT_NAME = 'FulfillmentApi'
HTTP_HEADERS = { 'Access-Control-Allow-Origin' => '*' }.freeze
USERS_TABLE_NAME = ENV['USERS_TABLE_NAME'] || 'users-table-test'
ENVS = {
  test: 'test',
  dev: 'dev',
  prod: 'prod'
}.freeze

def lambda_handler(event = {}, _context = {})
  resource = event.dig(:event, 'resource')
  http_method = event.dig(:event, 'httpMethod')
  params = event.dig(:event, 'queryStringParameters')
  stage = event.dig(:event, 'requestContext', 'stage') || ENVS[:dev]

  Utils.log({ resource: resource, http_method: http_method, params: params, stage: stage })

  Database.new(stage)

  case resource
  when '/users'
    case http_method
    when 'POST'
      User.create(params)
    when 'GET'
      puts 'List users'
      User.list
    end
  end
end
