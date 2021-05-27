#This file is to help facilitate frontend objects that will be perceived by the user.

import psycopg2

def getSearchTypes():
    db = None
    ret_dict = {'types': []}
    try:
        db = psycopg2.connect("dbname=biological_systems")
        cursor = db.cursor()

        #Form the query to obtain the total types of entity types we can send as input.
        query = """
                    select * from obtainEntityTypes()
                """
        cursor.execute(query)

        for types in cursor.fetchall():
            ret_dict['types'].append(types[0])

    except psycopg2.error as err:
        print(err)
    return ret_dict