import os
import pytest
import boto3
from moto import mock_dynamodb

from python.src.app.storage import DynamoDBUserStorage
from python.src.app.models import User, Birthday


@pytest.fixture(scope='function')
def dynamodb_table():
    with mock_dynamodb():
        # Create a mock DynamoDB table
        table_name = 'users'
        dynamodb = boto3.resource('dynamodb', region_name='eu-west-1')
        table = dynamodb.create_table(
            TableName=table_name,
            KeySchema=[
                {
                    'AttributeName': 'username',
                    'KeyType': 'HASH'
                }
            ],
            AttributeDefinitions=[
                {
                    'AttributeName': 'username',
                    'AttributeType': 'S'
                }
            ],
            ProvisionedThroughput={
                'ReadCapacityUnits': 5,
                'WriteCapacityUnits': 5
            }
        )
        yield table


@pytest.fixture(scope='function')
def user_storage(dynamodb_table):
    # Initialize the DynamoDBUserStorage object
    table_name = dynamodb_table.name
    storage = DynamoDBUserStorage(table_name=table_name)
    return storage


def test_dynamodb_user_storage(user_storage):
    # Given
    user = User(username="Kostas", dateOfBirth=Birthday(value="2000-01-01"))

    # When
    user_storage.put_user(user)
    response = user_storage.table.get_item(Key={'username': user.username})

    # Then
    assert response['Item'] == {
        'username': user.username,
        'dateOfBirth': user.dateOfBirth.get_date()
    }

    # When
    retrieved_user = user_storage.get_user('Kostas')

    # Then
    assert retrieved_user.username == user.username
    assert retrieved_user.dateOfBirth == user.dateOfBirth
