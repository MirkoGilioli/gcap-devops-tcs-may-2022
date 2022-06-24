from app import flask_app
import googleclouddebugger


if __name__ == '__main__':
    try:
        googleclouddebugger.enable()
    except ImportError:
        pass
    flask_app.run(debug=True, host='0.0.0.0', port=8080)