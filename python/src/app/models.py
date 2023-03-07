from datetime import date, datetime

from pydantic import BaseModel, validator, Field


class Birthday(BaseModel):
    format: str = Field(default="%Y-%m-%d")
    value: date

    @validator('value')
    def date_must_be_in_past(cls, value, values):
        try:
            datetime.strptime(str(value), values['format'])
        except ValueError:
            raise
        assert value < datetime.now().date(), 'dateOfBirth cannot be in the future'
        return value

    def get_days_until_birthday(self) -> int:
        """Returns number of days until next birthday"""
        dob = date.fromisoformat(str(self.value))
        today = date.today()
        next_birthday = date(today.year, dob.month, dob.day)
        if next_birthday < today:
            next_birthday = date(today.year + 1, dob.month, dob.day)
        days_to_birthday = (next_birthday - today).days
        return days_to_birthday

    class Config:
        allow_mutation = False


class User(BaseModel):
    """Class representing the user model"""
    username: str
    dateOfBirth: Birthday

    @validator('username')
    def username_must_contain_only_letters(cls, v):
        assert v.isalpha(), 'username must contain only letters'
        return v

    class Config:
        allow_mutation = False


class HelloResponse(BaseModel):
    message: str
