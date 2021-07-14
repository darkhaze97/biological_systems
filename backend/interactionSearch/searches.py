#!/usr/bin/python3

import sys
import psycopg2

from .searchHelper import handleInteractions


#The user passes in the inputs into the functions. Note that the entitytype can be compounded.
#E.g. molecule-protein, living-bacteria. This is so that the user can define a lower level of the 
#type that they are searching for.

def search(entity1, entity1Type, entity2, entity2Type):
    #This accounts for whether the user has entered any input at all for both molecules. If no input for any of the molecules,
    #then it is assumed that the user is referring to an interaction between ALL molecules 

    db = None
    return_dict = {}
    ret_list = []
    try:
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()

        #Search for names in the db. The db returns tuples to here. From here, the user chooses which molecules 
        #to use. Note that the interactions between any similar matching molecules are shown (if 2 molecules are provided and there are
        #no exact matches)
        #and if only one molecule is provided, then interactions are not provided.
        #Tomorrow: Split the algorithms for each case. Devise what to do for each.

        #Should make a file that helps sort out which entity1Type or entity2Type connections to use...

        #Specific and specific case
        #Cool note: May not need to separate specific and non-specific cases if I am writing the functions
        #in plpgsql --> check specificSearch makeSpecificItem, because I can also put in the general case there, and then
        #make a general case object

        #First, split entity1Type and entity2Type into it's upper and 
        #lower constituents. E.g. Molecule (Protein) split into Molecule
        #and Protein separately.

        entity1TypeArray = entity1Type.split(" (")
        entity1TypeUpper = entity1TypeArray[0]
        #Check if there was a lower type specified before obtaining it.
        entity1TypeLower = ""
        if (len(entity1TypeArray) > 1):
            entity1TypeLower = entity1TypeArray[1]
            #Remove the '(' and ')' in front of entity1TypeLower.
            entity1TypeLower = entity1TypeLower[:len(entity1TypeLower) - 1]

        print(entity1TypeUpper)
        print(entity1TypeLower)

        entity2TypeArray = entity2Type.split(" (")
        entity2TypeUpper = entity2TypeArray[0]
        entity2TypeLower = ""
        if (len(entity2TypeArray) > 1):
            entity2TypeLower = entity2TypeArray[1]
            #Remove the '(' and ')' in front of the entity2TypeLower.
            entity2TypeLower = entity2TypeLower[:len(entity2TypeLower) - 1]

        cursor.execute("select * from searchInteractions(%s, %s, %s, %s)", [entity1, entity1TypeUpper, entity2, entity2TypeUpper])

        #Here, filter out the tuples based on the lower types. We will test types
        #based on the ordering of a type: nonSpecificInteractionInformation
        #defined in types.sql
        filtered_tups = []
        for tup in cursor.fetchall():
            print(tup)
            if ((tup[1] == entity1TypeLower and tup[4] == entity2TypeLower) or
                (tup[1] == entity2TypeLower and tup[4] == entity1TypeLower)):
                filtered_tups.append(tup)
            elif (entity1TypeUpper == "Any" and entity2TypeUpper == "Any"):
                filtered_tups.append(tup)
            elif (entity1TypeUpper == "Any" and (tup[4] == entity2TypeLower or tup[1] == entity2TypeLower)):
                filtered_tups.append(tup)
            elif (entity2TypeUpper == "Any" and (tup[4] == entity1TypeLower or tup[1] == entity1TypeLower)):
                filtered_tups.append(tup)

        print(filtered_tups)
        ret_list = handleInteractions(filtered_tups)

        

    except psycopg2.Error as err:
        print("DB Error: ", err)
    finally:
        print("Closing connection.")
        if (db):
            db.close()
    return ret_list