from abc import ABC, abstractmethod

import boto3
import os

from .models import User


class UserStorage(ABC):
    @abstractmethod
    def put_user(self, user: User) -> None:
        """Stores a user from storage"""
        ...

    @abstractmethod
    def get_user(self, username: str) -> User:
        """Retrieves a user from storage"""
        ...

    @abstractmethod
    def _setup_storage(self):
        """Setting up storage"""
        ...


class DynamoDBStorage(UserStorage):
    def __init__(self, table_name: str):
        self.dynamodb = boto3.resource(
            'dynamodb',
            region_name=os.getenv("AWS_REGION", 'eu-west-1'),
            endpoint_url=os.getenv('DYNAMODB_ENDPOINT', 'dynamodb.eu-west-1.amazonaws.com')
        )
        self.table_name = table_name
        self.table = self.dynamodb.Table(table_name)
        self._setup_storage()

    def _setup_storage(self) -> None:
        try:
            self.table.load()
        except self.dynamodb.meta.client.exceptions.ResourceNotFoundException:
            self._create_table(self.table_name)

    def _create_table(self, table_name: str):
        self.table = self.dynamodb.create_table(
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
        self.table.wait_until_exists()

    def put_user(self, user: User):
        item = {
            'username': user.username,
            'dateOfBirth': str(user.dateOfBirth),
        }
        self.table.put_item(Item=item)

    def get_user(self, username: str):
        response = self.table.get_item(Key={'username': username})
        return response.get('Item')
