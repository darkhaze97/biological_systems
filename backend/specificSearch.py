#!/usr/bin/python3

from proteinInteractions import *
from nucleicAcidInteractions import *

def makeSpecificItem(name1, type1, name2, type2):
    """
    This function helps create a new object that the user can use to ask a specific
    query (examples are shown above). It looks at the types of the molecules that were provided by the user,
    and creates the relevant object for these molecules. E.g. for a protein - nucleic acid interaction,
    we will create an object, proteinNucleicAcid.
    """
    #This may get a bit hard codey... Perhaps there is a better way to do this?
    if (type1 == "PROTEIN" and type2 == "NUCLEIC ACID"):
        return proteinNucleicAcid(name1, name2)
    elif (type1 == "NUCLEIC ACID" and type2 == "PROTEIN"):
        return proteinNucleicAcid(name2, name1)
    elif (type1 == "PROTEIN" and type2 == "PROTEIN"):
        return proteinProtein(name1, name2)