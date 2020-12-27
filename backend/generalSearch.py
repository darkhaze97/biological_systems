#!/usr/bin/python3

import sys

from abc import ABC, abstractmethod

from specificSearch import *

#Note that for the general search, I will be using many segments of the specific
#search.
class generalSearch(ABC):
    molecule1 = None
    molecule2 = None
    ret_dict = None
    

class generalGeneral(generalSearch):
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
        self.ret_dict = {}
    def query(self, cursor):
        ret_tups = []
        queryObject = proteinNucleicAcid(self.molecule1, self.molecule2)
        self.addToRetDict(cursor, queryObject)
        #Note that for the general case, we must flip the direction of the molecules to test
        #if we can find instances of them in the other table
        queryObject = proteinNucleicAcid(self.molecule2, self.molecule1)
        self.addToRetDict(cursor, queryObject)
        #Now, we have to flip molecule1
    def getTuples(self):
        return self.ret_dict
    def addToRetDict(self, cursor, queryObject):
        queryObject.query(cursor)
        ret_tups = queryObject.getTuples()
        for key in ret_tups:
            self.ret_dict[key] = ret_tups[key]

#class generalProtein():
#Make sure that the order of the molecules that are passed in are maintained
#For this case, we would search through every 

#class generalNucleicAcid():


def makeGeneralItem(name1, type1, name2, type2):
    """
        This function helps create a new object that the user can ask general
        queries on. Note that this will include the general + specific case as well.
    """
    if (type1 == "ANY" and type2 == "ANY"):
        print("Making a very general search object")
        return generalGeneral(name1, name2)
    elif (type1 == "ANY" and type2 != "ANY"):
        print("Making a half general search object")
    elif (type1 != "ANY" and type2 == "ANY"):
        print("Making a half general search object")


