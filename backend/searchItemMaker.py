#!/usr/bin/python3
import sys

from abc import ABC, abstractmethod

class searchItem(ABC):
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
            print(tup)
            molecule1 = tup[0] + "/" + tup[1]
            molecule2 = tup[2] + "/" + tup[3]
            if (molecule1 not in interaction_dict.keys()):
                #If we do not have the tuple as a key yet, add it, and make it point to a
                #list (of dictionaries)
                ret_dict[molecule1] = []
            interaction_dict[molecule2] = []
            #Scan through the return tuple list, only adding on if we have values for the tuples...
            for i in range(4, len(tup)):
                if (tup[i] == True):
                    interaction_dict[molecule2].append(column_names[i])
            ret_dict[molecule1].append(interaction_dict)

class uniqueMolecules(searchItem):
    def query(self, cursor):
        #Note that we have 4 variables to pass in, so that we can account for if molecule1 or molecule2 is the protein.
        cursor.execute(self.queryString, [self.molecule1, self.molecule2])
        self.tuples = cursor.fetchall()
        self.column_names = [desc[0] for desc in cursor.description]
        #Below is for the reverse direction: Nucleic Acid --> Protein
        cursor.execute(self.queryString2, [self.molecule2, self.molecule1])
        self.tuples2 = cursor.fetchall()
        self.column_names2 = [desc[0] for desc in cursor.description]

class identicalMolecules(searchItem):
    def query(self, cursor):
        #Protein1 --> Protein2
        cursor.execute(self.queryString, [self.molecule1, self.molecule2])
        self.tuples = cursor.fetchall()
        self.column_names = [desc[0] for desc in cursor.description]
        #Below is for the reverse direction: Protein2 --> Protein1
        cursor.execute(self.queryString, [self.molecule2, self.molecule1])
        self.tuples2 = cursor.fetchall()
        self.column_names2 = [desc[0] for desc in cursor.description]
