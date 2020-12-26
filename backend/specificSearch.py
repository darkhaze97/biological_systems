#!/usr/bin/python3

import sys

from abc import ABC, abstractmethod

class specificSearch(ABC):
    molecule1 = None
    molecule2 = None
    @abstractmethod
    def query(self):
        pass

class proteinNucleicAcid(specificSearch):
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
    def query(self):
        #Should call a protein-nucleicacid specific plpgsql function
        #Note: The general case should call this same plpgsql function along with the other query functions of
        #other interaction classes
        print("This is a protein vs nucleic acid analysis of " + self.molecule1 + " and " + self.molecule2)





#We should make a function that helps determine which class will be created for
#search file...
def makeSpecificItem(name1, type1, name2, type2):
    """
    This function helps create a new object that the user can use to ask a specific
    query (examples are shown above). It looks at the types of the molecules that were provided,
    noting that this is a specific search item.
    """
    #This may get a bit hard codey... Perhaps there is a better way to do this?
    if (type1 == "PROTEINS" and type2 == "NUCLEIC ACIDS"):
        return proteinNucleicAcid(name1, name2)
    elif (type1 == "NUCLEIC ACIDS" and type2 == "PROTEINS"):
        return proteinNucleicAcid(name2, name1)
    elif (type1 == "PROTEINS" and type2 == "PROTEINS"):
        return proteinProtein(name1, name2)