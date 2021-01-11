#!/usr/bin/python3

import sys
import psycopg2
import os

sys.path.insert(1, os.path.abspath(".."))

from backend import USERSEPARATOR
#USERSEPARATOR = "===###==="

#This separator is used with the files in interactionResultQueries.
#This should not be changed.
PREDEFINED_SEPARATOR = "===###==="

def getResult(molecule1, type1, molecule2, type2):
    #Depending on the type, I will need to perform different searches...
    #I will dynamically get the query...
    
    fileName = "_".join(type1.split(" ")) + "_" #This segment of code simply changes the spaces in type1
                                                #into _
    fileName = fileName + "_".join(type2.split(" ")) #Refer to the above comment.

    #Now, use the fileName to open the file and read in the query for that interaction.
    #I have done it this way to improve extensibility instead of using 'if' statements

    returnDict = {}

    file = None
    try:
        #First, connect to the db
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()
        #Then try to open the related file.
        file = open("./queries/" + fileName)
        queries = file.read()
        queryList = queries.split(PREDEFINED_SEPARATOR)
        
        cursor.execute(queryList[0], [molecule1])
        molecule1Info = cursor.fetchone()
        returnDict['molecule1'] = {}
        #The for loop below simply adds the information of molecule1 to the returnDictionary:
        #returnDict = {'molecule1': {'name': blah, 'bond_type': etc.}}
        for i in range(0, len(cursor.description)):
            returnDict['molecule1'][cursor.description[i][0]] = molecule1Info[i] 

        cursor.execute(queryList[1], [molecule2])
        molecule2Info = cursor.fetchone()
        returnDict['molecule2'] = {}
        #Refer to the comment above for the for loop below.
        for i in range(0, len(cursor.description)):
            returnDict['molecule2'][cursor.description[i][0]] = molecule2Info[i]

        cursor.execute(queryList[2], [molecule1, molecule2])
        interactionInfo = cursor.fetchall()
        #interactionInfo currently contains all the tuples: [(category, name, info)]
        #category is simply the category of the interaction: codes for, binds to, etc.
        #name is the specifics for that category: e.g. Polymerase binds to gene
        #info is the info associated with the specifics for the category.

        #To make the code below more readable, I will convert the columns of the return
        #into a more understandable variable.
        nameColumn = cursor.description[1][0]
        infoColumn = cursor.description[2][0]

        returnDict['interactions'] = {}
        #The for loop below handles the information and separates them into dictionaries
        for tup in interactionInfo:
            returnDict['interactions'][tup[0]] = {}
            #Add the name of the interaction on.
            returnDict['interactions'][tup[0]][nameColumn] = tup[1]

            returnDict['interactions'][tup[0]][infoColumn] = {}

            #Now, we need to split the information to filter out information from something like:
            #effect: hi===###===motif: hook, where ===###=== is the separator.
            informationList = tup[2].split(USERSEPARATOR)

            #informationList now contains a list of info like so:
            #['effect: blah', 'motif: blah']
            #Now, we need to separate out the header for the information.

            for text in informationList:
                splitText = text.split(": ")
                #splitText contains something like: ['effect', 'Blah']. We use the 0'th
                #element as the key for the 1'st element
                key = splitText.pop(0)
                infoText = ": ".join(splitText)
                returnDict['interactions'][tup[0]][infoColumn][key] = infoText

        #Return will look like: {molecule1: {info1: blah, info2: blah}, molecule2: {info1: blah, info2: blah},
        #                        interactions: {codes_for: {info1: blah, info2: blah}, binds_to: {info1: blah}}}
    except IOError or psycopg2.Error:
        print("Error")
    finally:
        if file:
            file.close()
    return returnDict

    
