#!/usr/bin/python3

import sys
from flask import Flask, request
from flask_cors import CORS
import os
from json import dumps

from search import searchTwo
from interactionResult import getResult

def defaultHandler(err):
    response = err.get_response()
    print('response', err, err.get_response())
    response.data = dumps({
        "code": err.code,
        "name": "System Error",
        "message": err.get_description(),
    })
    response.content_type = 'application/json'
    return response

APP = Flask(__name__)
CORS(APP)

APP.config['TRAP_HTTP_EXCEPTIONS'] = True
APP.register_error_handler(Exception, defaultHandler)

@APP.route("/interactions/results/all", methods=['POST'])
def interactions():
    # We want to receive the data from the caller.
    payload = request.get_json()
    print(payload)
    interaction_info = searchTwo(payload['molecule1'], payload['type1'], payload['molecule2'], payload['type2'])
    print(interaction_info)
    return dumps(interaction_info)

@APP.route("/interactions/results/specific", methods=['POST'])
def specificInteraction():
    payload = request.get_json()
    print(payload)
    specificInteractionInfo = getResult(payload['molecule1'], payload['type1'], payload['molecule2'], payload['type2'])
    print(specificInteractionInfo)
    return dumps(specificInteractionInfo)

if __name__ == "__main__":
    APP.run(port=(int(sys.argv[1]) if len(sys.argv) == 2 else 8080))