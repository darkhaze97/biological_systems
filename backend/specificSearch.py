#!/usr/bin/python3

import sys

from abc import ABC, abstractmethod

class specificSearch(ABC):
    molecule1 = None
    molecule2 = None
    queryString = None
    queryString2 = None
    tuples = None
    tuples2 = None
    column_names = None
    column_names2 = None
    @abstractmethod
    def query(self, cursor):
        pass
    @abstractmethod
    def getTuples(self):
        pass
    def checkInteractions(self, ret_dict, tups, column_names):
        interaction_dict = {}
        for tup in tups:
            if (tup[0] not in interaction_dict.keys()):
                #If we do not have the tuple as a key yet, add it, and make it point to a
                #list (of dictionaries)
                ret_dict[tup[0]] = []
            interaction_dict[tup[2]] = []
            #Scan through the return tuple list, only adding on if we have values for the tuples...
            for i in range(4, len(tup)):
                if (tup[i] == True):
                    interaction_dict[tup[2]].append(column_names[i])
            ret_dict[tup[0]].append(interaction_dict)


class proteinNucleicAcid(specificSearch):
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
        self.queryString =  """
                                select * from proteinNucleicAcid(%s, %s)
                            """
        self.queryString2 = """
                                select * from nucleicAcidProtein(%s, %s)
                            """
    def query(self, cursor):
        cursor.execute(self.queryString, [self.molecule1, self.molecule2])
        self.tuples = cursor.fetchall()
        self.column_names = [desc[0] for desc in cursor.description]
        #Below is for the reverse direction: Nucleic Acid --> Protein
        cursor.execute(self.queryString2, [self.molecule1, self.molecule2])
        self.tuples2 = cursor.fetchall()
        self.column_names2 = [desc[0] for desc in cursor.description]
    def getTuples(self):
        #{molecule1: [{molecule2: []}], molecule2: [{molecule1: []}]} This is how I want to store all the data...
        #I have structured it this way so that I can ensure directionality remains... E.g. nucleic acid CODES for protein,
        #not the other way around. This means that we have to have more queries to account for the reverse direction.
        ret_dict = {}
        super().checkInteractions(ret_dict, self.tuples, self.column_names)
        super().checkInteractions(ret_dict, self.tuples2, self.column_names2)
        return ret_dict

class proteinProtein(specificSearch):
    def __init__(self, name1, name2):
        self.molecule1 = name1
        self.molecule2 = name2
        self.queryString = """
                            select * from proteinProtein(%s, %s)
                           """
        #Note: Here, we will call the queryString twice, but change the order of molecule1 and 2
        #as the arguments
    def query(self, cursor):
        cursor.execute(self.queryString, [self.molecule1, self.molecule2])
        self.tuples = cursor.fetchall()
    def getTuples(self):
        return self.tuples




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