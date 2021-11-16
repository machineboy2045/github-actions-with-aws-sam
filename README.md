# fulfillments-api

This project contains source code and supporting files for a serverless application that you can deploy with the SAM CLI.


The application uses several AWS resources, including Lambda functions and an API Gateway API. These resources are defined in the `template.yaml` file in this project. You can update the template to add AWS resources.

## Testing
```
# build
sam build

# Start local dynamodb
docker-compose up



# Run tests
bundle exec rspec

```

## Useful commands
```
# List tables locally
aws dynamodb list-tables --endpoint-url http://localhost:8001

sam local start-api -p 3001 --env-vars test_env.json --docker-network github-actions-with-aws-sam_default

# Open console
bundle exec irb -r ./api_function/app.rb

```