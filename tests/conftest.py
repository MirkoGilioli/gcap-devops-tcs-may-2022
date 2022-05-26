import pytest
from app import flask_app

@pytest.fixture
def client():
    return flask_app.test_client()