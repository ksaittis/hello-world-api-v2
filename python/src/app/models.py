from datetime import date

from pydantic import BaseModel, validator


class User(BaseModel):
    """Class representing the user model"""
    username: str
    dateOfBirth: date

    @validator('username')
    def username_must_contain_only_letters(cls, v):
        assert v.isalpha(), 'username must contain only letters'
        return v

    @validator('dateOfBirth')
    def date_must_be_in_past(cls, v):
        assert v < date.today(), 'dateOfBirth must be in the past'
        return v

    class Config:
        allow_mutation = False


class HelloResponse(BaseModel):
    message: str
