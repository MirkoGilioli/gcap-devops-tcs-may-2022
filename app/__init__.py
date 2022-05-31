from flask import Flask

flask_app = Flask(__name__)

# Importing the routes file
from app import routes
# Importing the error_handlers
from app import error_handlers