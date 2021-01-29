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