#!/usr/bin/python3

import sys
from flask import Flask, request
from flask_cors import CORS
import os
from json import dumps

from interactionSearch import search, getResult, obtainEntityTypes
from biologicalConcepts import conceptSearch, specificConceptSearch, getConceptEntities, getConceptEntitySpecific

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

#Interactions:

@APP.route("/interactions/obtain/presentation", methods=['GET'])
def interactionFrontendPresentation():
    #We want to send the data to the caller.
    return dumps(obtainEntityTypes())

@APP.route("/interactions/results/all", methods=['POST'])
def interactions():
    # We want to receive the data from the caller.
    payload = request.get_json()
    print(payload)
    interaction_info = search(payload['entity1'], payload['type1'], payload['entity2'], payload['type2'])
    print(interaction_info)
    return dumps(interaction_info)

@APP.route("/interactions/results/specific", methods=['POST'])
def specificInteraction():
    payload = request.get_json()
    print(payload)
    specificInteractionInfo = getResult(payload['id1'], payload['type1'], payload['id2'], payload['type2'])
    print(specificInteractionInfo)
    return dumps(specificInteractionInfo)

#Concepts:

@APP.route("/concepts/results/all", methods=['POST'])
def concepts():
    payload = request.get_json()
    print(payload)
    conceptInfo = conceptSearch(payload['name'])
    return dumps(conceptInfo)

@APP.route("/concepts/results/specific", methods=['POST'])
def specificConcept():
    ret_dict = {}
    payload = request.get_json()
    print(payload)
    conceptSpecifics = specificConceptSearch(payload['id'])
    ret_dict['conceptInfo'] = conceptSpecifics
    conceptEntities = getConceptEntities(payload['id'])
    ret_dict['conceptEntities'] = conceptEntities
    return dumps(ret_dict)

@APP.route("/concepts/results/entities/information", methods=['POST'])
def specificConceptEntitiesInformation():
    payload = request.get_json()
    print(payload)
    ret_dict = getConceptEntitySpecific(payload)
    return ret_dict
    

if __name__ == "__main__":
    APP.run(port=(int(sys.argv[1]) if len(sys.argv) == 2 else 8080))