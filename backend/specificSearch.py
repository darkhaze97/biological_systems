#!/usr/bin/python3

import sys

from abc import ABC, abstractmethod

class specificSearch(ABC):
    molecule1 = None
    molecule2 = None
    type1 = None
    type2 = None
    queryString = None
    queryString2 = None
    tuples = None
    tuples2 = None
    column_names = None
    column_names2 = None
    @abstractmethod
    def query(self, cursor):
        pass
    def getTuples(self):
        #{molecule1: [{molecule2: []}], molecule2: [{molecule1: []}]} This is how I want to store all the data...
        #I have structured it this way so that I can ensure directionality remains... E.g. nucleic acid CODES for protein,
        #not the other way around. This means that we have to have more queries to account for the reverse direction.
        ret_dict = {}
        self.checkInteractions(ret_dict, self.tuples, self.column_names)
        self.checkInteractions(ret_dict, self.tuples2, self.column_names2)
        return ret_dict
    def checkInteractions(self, ret_dict, tups, column_names):
        interaction_dict = {}
        for tup in tups:
            if ((tup[0], tup[1], tup[2]) not in interaction_dict.keys()):
                #If we do not have the tuple as a key yet, add it, and make it point to a
                #list (of dictionaries)
                ret_dict[(tup[0], tup[1], tup[2])] = []
            interaction_dict[(tup[3], tup[4], tup[5])] = []
            #Scan through the return tuple list, only adding on if we have values for the tuples...
            for i in range(6, len(tup)):
                if (tup[i] == True):
                    interaction_dict[(tup[3], tup[4], tup[5])].append(column_names[i])
            ret_dict[(tup[0], tup[1], tup[2])].append(interaction_dict)

class uniqueMolecules(specificSearch):
    def query(self, cursor):
        #Note that we have 4 variables to pass in, so that we can account for if molecule1 or molecule2 is the protein.
        cursor.execute(self.queryString, [self.molecule1, self.molecule2])
        self.tuples = cursor.fetchall()
        self.column_names = [desc[0] for desc in cursor.description]
        #Below is for the reverse direction: Nucleic Acid --> Protein
        cursor.execute(self.queryString2, [self.molecule1, self.molecule2])
        self.tuples2 = cursor.fetchall()
        self.column_names2 = [desc[0] for desc in cursor.description]

class identicalMolecules(specificSearch):
    def query(self, cursor):
        #Protein1 --> Protein2
        cursor.execute(self.queryString, [self.molecule1, self.molecule2])
        self.tuples = cursor.fetchall()
        self.column_names = [desc[0] for desc in cursor.description]
        #Below is for the reverse direction: Protein2 --> Protein1
        cursor.execute(self.queryString, [self.molecule2, self.molecule1])
        self.tuples2 = cursor.fetchall()
        self.column_names2 = [desc[0] for desc in cursor.description]

#Below will be the specific classes that will be instantiated. 

class proteinNucleicAcid(uniqueMolecules):
    """
        This class deals with all the protein --> Nucleic acid interactions as well as
        the nucleic acid --> protein interactions
    """
    def __init__(self, name1, name2):
        """
            Here, molecule1 is the protein, and molecule2 is the nucleic acid.
        """
        self.molecule1 = name1
        self.molecule2 = name2
        self.type1 = "PROTEIN"
        self.type2 = "NUCLEIC ACID"
        self.queryString =  """
                                select * from proteinNucleicAcid(%s, %s)
                            """
        self.queryString2 = """
                                select * from nucleicAcidProtein(%s, %s)
                            """

class proteinProtein(identicalMolecules):
    def __init__(self, name1, name2):
        """
            Here, both molecules are proteins.
        """
        self.molecule1 = name1
        self.molecule2 = name2
        self.type1 = "PROTEIN"
        self.type2 = "PROTEIN"
        self.queryString = """
                            select * from proteinProtein(%s, %s)
                           """
        #Note: Here, we will call the queryString twice, but change the order of molecule1 and 2
        #as the arguments

class nucleicAcidNucleicAcid(identicalMolecules):
    def __init__(self, name1, name2):
        """
            Here, both molecules are nucleic acids.
        """
        self.molecule1 = name1
        self.molecule2 = name2
        self.type1 = "NUCLEIC ACID"
        self.type2 = "NUCLEIC ACID"
        self.queryString =  """
                                select * from nucleicAcidNucleicAcid(%s, %s)
                            """



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