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
        assert v < date.today(), 'dateOfBirth cannot be in the past'
        return v

    def get_days_until_birthday(self) -> int:
        """Returns number of days until next birthday"""
        dob = date.fromisoformat(str(self.dateOfBirth))
        today = date.today()
        next_birthday = date(today.year, dob.month, dob.day)
        if next_birthday < today:
            next_birthday = date(today.year + 1, dob.month, dob.day)
        days_to_birthday = (next_birthday - today).days
        return days_to_birthday

    class Config:
        allow_mutation = False


class HelloResponse(BaseModel):
    message: str
