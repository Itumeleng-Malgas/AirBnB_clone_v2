#!/usr/bin/python3
# Script that starts a Flask web application.

from flask import Flask

app = Flask(__name__)


# Route to display "Hello HBNB!"
@app.route('/', strict_slashes=False)
def hello_hbnb():
    """ Function that return Hello HBNB """
    return 'Hello HBNB!'


if __name__ == '__main__':
    # Run the application on 0.0.0.0 and port 5000
    app.run(host='0.0.0.0', port=5000)
