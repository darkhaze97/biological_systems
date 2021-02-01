#!/usr/bin/python3

import psycopg2

#Note that the function below is for the general search of a concept. It can return multiple concepts that the user 
# can select.
def conceptSearch(name):
    db = None
    ret_list = []

    try:
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()

        query = """
                    select *
                        from    searchConcept(%s)
                """
        
        cursor.execute(query, [name])

        for tup in cursor.fetchall():
            conceptName = tup[0] + "/" + tup[1];
            ret_list.append({conceptName: tup[2]})
    except psycopg2.Error as err:
        print(err)
    finally:
        if (db):
            db.close()
    return ret_list

def specificConceptSearch(id):
    db = None
    ret_dict = {}
    try:
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()
        query = """
                    select *
                        from    specificConceptSearch(%s)
                """
        cursor.execute(query, [id])
        tup = cursor.fetchone()
        for i in range(0, len(tup)):
            ret_dict[cursor.description[i][0]] = tup[i]
    except psycopg2.Error as err:
        print(err)
    finally:
        if (db):
            db.close()
    return ret_dict


def getConceptMolecules(id):
    db = None
    ret_list = []
    try:
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()
        query = """
                    select *
                        from    getConceptMolecules(%s)
                """
        cursor.execute(query, [id])
        conceptDict = {}
        for tup in cursor.fetchall():
            for i in range(0, len(tup)):
                conceptDict[cursor.description[i][0]] = tup[i]
            ret_list.append(conceptDict)
    except psycopg2.Error as err:
        print(err)
    finally:
        if (db):
            db.close()
    return ret_list