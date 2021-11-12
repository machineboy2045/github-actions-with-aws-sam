# frozen_string_literal: true

require 'spec_helper'
require './fulfillments_api/app'

RSpec.describe 'app' do
  let(:stage) { ENVS[:test] }
  before do
    db = Database.new(stage)
    db.clear
    db.migrate
  end

  describe 'users' do
    it 'creates' do
      lambda_handler(
        {
          event: {
            'requestContext' => { 'stage' => stage },
            'resource' => '/users',
            'httpMethod' => 'POST',
            'queryStringParameters' => { 'name' => 'Billy Bob' }
          }
        }
      )

      response = lambda_handler(
        {
          event: {
            'requestContext' => { 'stage' => stage },
            'resource' => '/users',
            'httpMethod' => 'GET'
          }
        }
      )

      expect(JSON.parse(response[:body]).first['name']).to eq('Billy Bob')
    end
  end
end
