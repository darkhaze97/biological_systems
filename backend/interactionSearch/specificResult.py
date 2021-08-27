#!/usr/bin/python3

import sys
import psycopg2
import os

sys.path.insert(1, os.path.abspath(".."))

from backend import USERSEPARATOR
#USERSEPARATOR = "===###==="

#This contains the path for the location of THIS file, instead of the server.
cur_path = os.path.dirname(__file__)

#This separator is used with the files in interactionResultQueries.
#This should not be changed.
PREDEFINED_SEPARATOR = "===###==="

#Precond: Type1 and type2 are a lower type (e.g. Protein, Bacteria. NOT Molecules, Living, Non-living)
def getResult(id1, type1, id2, type2):
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

        ############################################################# USE getUpperType(id1 integer) to grab the upper type, so we
        #################don't join with Molecules m only...

        # Below are queries to get the upper type of the entity (e.g. Molecule, Living, Non-living)
        queryString1 = f"select * from getUpperType({id1})"
        queryString2 = f"select * from getUpperType({id2})"

        # Get the upper type of the first molecule.
        cursor.execute(queryString1)
        upperType1 = (cursor.fetchone())[0] + "s"

        # Get the lower type of the second molecule.
        cursor.execute(queryString2)
        upperType2 = (cursor.fetchone())[0] + "s"

        #Below changes upperType1 into a table name format.
        "_".join(upperType1.split(" "))
        #Below changes upperType2 into a table name format
        "_".join(upperType2.split(" "))

        #Below changes type1 into a table name format.
        lowerType1 = "_".join(type1.split(" ")) + "s"
        #Below changes type2 into a table name format.
        lowerType2 = "_".join(type2.split(" ")) + "s"

        queryString1 = f"""
                            select *
                            from    Entities e
                                    join {upperType1} ut1 on (ut1.id = e.id)
                                    join {lowerType1} lt1 on (lt1.id = ut1.id)
                            where e.id = %s and ut1.type = %s
                        """

        queryString2 = f"""
                            select *
                            from    Entities e
                                    join {upperType2} ut2 on (ut2.id = e.id)
                                    join {lowerType2} lt2 on (lt2.id = ut2.id)
                            where e.id = %s and ut2.type = %s
                        """
        #Grab information about molecule 1.
        cursor.execute(queryString1, [id1, type1])
        entity1Info = cursor.fetchone()
        returnDict['entity1'] = {}
        #The for loop below simply adds the information of entity1 to the returnDictionary:
        #returnDict = {'entity1': {'name': blah, 'bond_type': etc.}}
        for i in range(0, len(cursor.description)):
            returnDict['entity1'][cursor.description[i][0]] = entity1Info[i]
            #Note: even though there are two 'type' columns, this should not matter, since
            #returnDict['molecule#'][type] is set to the lower type (by way of structuring the
            #queries above)
        #Include the type of the molecule.
        returnDict['entity1']['type'] = (type1.lower()).capitalize()

        #Grab information about molecule 2.
        cursor.execute(queryString2, [id2, type2])
        entity2Info = cursor.fetchone()
        returnDict['entity2'] = {}
        #Refer to the comment above for the for loop below.
        for i in range(0, len(cursor.description)):
            returnDict['entity2'][cursor.description[i][0]] = entity2Info[i]
        #Include the type of the molecule.
        returnDict['entity2']['type'] = (type2.lower()).capitalize()

        query3 = "select * from getSpecificInteraction(%s, %s)"

        cursor.execute(query3, [id1, id2])
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

        #Return will look like: {entity1: {info1: blah, info2: blah}, entity2: {info1: blah, info2: blah},
        #                        interactions: {codes_for: {info1: blah, info2: blah}, binds_to: {info1: blah}}}
    except IOError or psycopg2.Error as err:
        print(err)
    finally:
        if file:
            file.close()
    return returnDict

    
