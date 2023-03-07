import pytest
from freezegun import freeze_time
from pydantic import ValidationError

from python.src.app.models import Birthday, User


@freeze_time("2020-01-01")
def test_valid_birthday():
    # Given
    birthday = Birthday(value="1987-04-03")

    # When
    actual_days_until_birthday = birthday.get_days_until_birthday()

    # Then
    assert actual_days_until_birthday == 93


@freeze_time("2020-01-01")
def test_birthday():
    # Given
    birthday = Birthday(value="1987-01-01")

    # When
    actual_days_until_birthday = birthday.get_days_until_birthday()

    # Then
    assert actual_days_until_birthday == 0


@freeze_time("2020-01-01")
def test_future_birthday():
    # Given
    # Then
    with pytest.raises(ValidationError):
        # When
        Birthday(value="2021-01-01")


@freeze_time("2020-01-01")
def test_invalid_format_birthday():
    # Given
    # Then
    with pytest.raises(ValidationError):
        # When
        Birthday(value="2000-01-010")


def test_valid_username():
    # Given
    user = User(username="Kostas", dateOfBirth=Birthday(value="2000-01-01"))

    # When
    assert user.username == "Kostas"


def test_invalid_username():
    # Given
    with pytest.raises(ValidationError):
        # When
        User(username="Kostas123", dateOfBirth=Birthday(value="2000-01-01"))
