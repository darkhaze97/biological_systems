#!/usr/bin/python3

import sys
import psycopg2

from .searchHelper import handleInteractions


#The user passes in the inputs into the functions.

def searchOne(molecule1, molecule1Type):
    db = None
    try:
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()
    except psycopg2.Error as err:
        print("DB Error: ", err)
    finally:
        print("Ending.")
        if (db):
            db.close()

def searchTwo(molecule1, molecule1Type, molecule2, molecule2Type):
    #First, change the molecule types into capitalised form, e.g. "Hi", "Police", etc.
    
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

        #Should make a file that helps sort out which molecule1Type or molecule2Type connections to use...

        #Specific and specific case
        #Cool note: May not need to separate specific and non-specific cases if I am writing the functions
        #in plpgsql --> check specificSearch makeSpecificItem, because I can also put in the general case there, and then
        #make a general case object

        cursor.execute("select * from searchTwoMolecules(%s, %s, %s, %s)", [molecule1, molecule1Type, molecule2, molecule2Type])
        ret_list = handleInteractions(cursor.fetchall())

        

    except psycopg2.Error as err:
        print("DB Error: ", err)
    finally:
        print("Closing connection.")
        if (db):
            db.close()
    return ret_list