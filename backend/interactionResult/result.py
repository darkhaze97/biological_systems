#!/usr/bin/python3

import sys
import psycopg2

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
        queryList = queries.split("===###===")
        
        cursor.execute(queryList[0], [molecule1])
        molecule1Info = cursor.fetchall()
        print(molecule1Info)
        molecule1Dict = {}
        print("Below is it")
        print(len(cursor.description))
        for i in range(0, len(cursor.description)):
            print(cursor.description[i][0])



        cursor.execute(queryList[1], [molecule2])
        molecule2Info = cursor.fetchall()
        print(molecule2Info)

        cursor.execute(queryList[2], [molecule1, molecule2])
        interactionInfo = cursor.fetchall()
        print(interactionInfo)


        #Return will look like: {molecule1: {info1: blah, info2: blah}, molecule2: {info1: blah, info2: blah},
        #                        interactions: {codes_for: {info1: blah, info2: blah}, binds_to: {info1: blah}}}
    except IOError or psycopg2.Error:
        print("Error")
    finally:
        if file:
            file.close()
    return returnDict

    
