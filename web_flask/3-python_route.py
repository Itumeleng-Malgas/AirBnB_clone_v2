#!/usr/bin/python3
""" Script that starts a Flask web application. """

from flask import Flask, escape

app = Flask(__name__)


@app.route('/', strict_slashes=False)
def hello_hbnb():
    """ Function that return Hello HBNB """
    return 'Hello HBNB!'


@app.route('/hbnb', strict_slashes=False)
def hbnb():
    """ Function that return HBNB """
    return 'HBNB'


@app.route('/c/<text>', strict_slashes=False)
def c_text(text):
    """ Return "C " followed by the value of the text variable """
    text = escape(text).replace('_', ' ')
    return f'C {text}'


@app.route('/python', strict_slashes=False)
@app.route('/python/<text>', strict_slashes=False)
def python_text(text='is cool'):
    """ Return  "Python ", followed by the value of the text """
    text = escape(text).replace('_', ' ')
    return f'Python {text}'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
