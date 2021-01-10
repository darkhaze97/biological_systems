#!/usr/bin/python3

#OVerall note on half general searches: I may have found out that
#the only thing that differs between general searches is the identical search case
#e.g. protein|general would require protein-protein checks.
#nucleic|general would not require a protein-protein check, but rather, a nucleic-nucleic check

import sys

from abc import ABC, abstractmethod

from .proteinInteractions import *
from .nucleicAcidInteractions import *

#Note that for the general search, I will be using many segments of the specific
#search.
class generalSearch(ABC):
    molecule1 = None
    molecule2 = None
    ret_dict = None
    @abstractmethod
    def query(self, cursor):
        pass
    def getTuples(self):
        return self.ret_dict
    def addToRetDict(self, cursor, queryObject):
        queryObject.query(cursor)
        ret_tups = queryObject.getTuples()
        for key in ret_tups:
            self.ret_dict[key] = ret_tups[key]

class generalGeneral(generalSearch):
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
        self.ret_dict = {}
    def query(self, cursor):
        #Considering protein --> Nucleic acid and nucleic acid --> protein interactions
        queryObject = proteinNucleicAcid(self.molecule1, self.molecule2)
        self.addToRetDict(cursor, queryObject)
        #Note that for the general case, we must flip the direction of the molecules to test
        #if we can find instances of them in the other table
        queryObject = proteinNucleicAcid(self.molecule2, self.molecule1)
        self.addToRetDict(cursor, queryObject)
        #Considering Protein --> Protein interactions
        queryObject = proteinProtein(self.molecule1, self.molecule2)
        self.addToRetDict(cursor, queryObject)
        #Considering Nucleic acid --> Nucleic acid interactions
        queryObject = nucleicAcidNucleicAcid(self.molecule1, self.molecule2)
        self.addToRetDict(cursor, queryObject)

class generalProtein(generalSearch):
    """
        I will be assuming molecule1 is the general molecule
    """
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
        self.ret_dict = {}
    def query(self, cursor):
        queryObject = proteinNucleicAcid(self.molecule2, self.molecule1)
        self.addToRetDict(cursor, queryObject)
        queryObject = proteinProtein(self.molecule1, self.molecule2)
        self.addToRetDict(cursor, queryObject)
    
#Make sure that the order of the molecules that are passed in are maintained
#For this case, we would search through every 

class generalNucleicAcid(generalSearch):
    """
        I will be assuming molecule1 is the general molecule
    """
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
        self.ret_dict = {}
    def query(self, cursor):
        queryObject = proteinNucleicAcid(self.molecule1, self.molecule2)
        self.addToRetDict(cursor, queryObject)

def makeGeneralItem(name1, type1, name2, type2):
    """
        This function helps create a new object that the user can ask general
        queries on. Note that this will include the general + specific case as well.
    """
    if (type1 == "ANY" and type2 == "ANY"):
        return generalGeneral(name1, name2)
    elif (type1 == "ANY" and type2 != "ANY"):
        return makeHalfGeneralItem(name1, type1, name2, type2)
    elif (type1 != "ANY" and type2 == "ANY"):
        return makeHalfGeneralItem(name2, type2, name1, type1)

def makeHalfGeneralItem(name1, type1, name2, type2):
    #In this case, name1 will be the general item, and name2 will be the non-general item
    if (type2 == "PROTEIN"):
        return generalProtein(name1, name2)
    elif (type2 == "NUCLEIC ACID"):
        return generalNucleicAcid(name1, name2)