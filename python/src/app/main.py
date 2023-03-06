from datetime import date

from fastapi import FastAPI, HTTPException
from starlette import status

from .models import User
from .storage import UserStorage, DynamoDBStorage

app = FastAPI()
storage: UserStorage = DynamoDBStorage(table_name='users')


@app.put("/hello/{username}", status_code=status.HTTP_204_NO_CONTENT)
def create_user(user: User):
    try:
        storage.put_user(user)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    return None


@app.get("/hello/{username}")
def greet_user(username: str):
    user = storage.get_user(username)

    if user is None:
        message = f"Hello, {username}!"
    else:
        dob = date.fromisoformat(user['dateOfBirth'])
        today = date.today()
        next_birthday = date(today.year, dob.month, dob.day)
        if next_birthday < today:
            next_birthday = date(today.year + 1, dob.month, dob.day)
        days_to_birthday = (next_birthday - today).days
        if days_to_birthday == 0:
            message = f"Hello, {username}! Happy birthday!"
        else:
            message = f"Hello, {username}! Your birthday is in {days_to_birthday} day(s)"
    return {'message': message}
