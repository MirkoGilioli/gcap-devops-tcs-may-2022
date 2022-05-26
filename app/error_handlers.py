from app import flask_app
from flask import json
from werkzeug.exceptions import HTTPException
# Imports Python standard library logging
import logging

# This handles method HTTPException like 404 or 405 
@flask_app.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = e.get_response()
    # replace the body with JSON
    response.data = json.dumps({
        "code": e.code,
        "name": e.name,
        "description": e.description,
    })
    response.content_type = "application/json"
    return response
