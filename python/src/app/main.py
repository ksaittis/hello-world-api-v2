from fastapi import FastAPI, HTTPException, Depends
from starlette import status

from .models import User
from .storage import UserStorage, DynamoDBUserStorage

app = FastAPI()


def get_storage():
    # Here we can inject different UserStorages
    storage: UserStorage = DynamoDBUserStorage(table_name='users')
    return storage


@app.put("/hello/{username}", status_code=status.HTTP_204_NO_CONTENT)
def create_user(user: User, storage: UserStorage = Depends(get_storage)):
    try:
        storage.put_user(user)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    return None


def get_greeting_message(username: str, days_to_birthday: int) -> str:
    if days_to_birthday == 0:
        return f"Hello, {username}! Happy birthday!"
    else:
        return f"Hello, {username}! Your birthday is in {days_to_birthday} day(s)"


@app.get("/hello/{username}")
def greet_user(username: str, storage: UserStorage = Depends(get_storage)):
    user = storage.get_user(username)

    if user is None:
        message = f"Hello, {username}!"
    else:
        days_to_birthday = user.dateOfBirth.get_days_until_birthday()
        message = get_greeting_message(username, days_to_birthday)

    return {'message': message}
