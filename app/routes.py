from app import flask_app

@flask_app.route('/')
def home():
    return 'Wecolme to Google Cloud DevOps!!!'

@flask_app.route('/about')
def about():
    return 'Welcome this is the about Page'

@flask_app.route('/help')
def help():
    return 'Welcome this is the help Page'
