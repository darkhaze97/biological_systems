"""
This file contains error codes and messages for the server.
"""
from werkzeug.exceptions import HTTPException

class AccessError(HTTPException):
    code = 400
    message = 'No message specified'

class InputError(HTTPException):
    code = 400
    message = 'No message specified'