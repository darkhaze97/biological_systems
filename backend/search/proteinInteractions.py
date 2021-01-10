#!/usr/bin/python3
"""
    This file helps model protein interaction with other molecules.
"""

from .searchItemMaker import uniqueMolecules, identicalMolecules

class proteinNucleicAcid(uniqueMolecules):
    """
        This class deals with all the protein --> Nucleic acid interactions as well as
        the nucleic acid --> protein interactions. This means that I do not need to put
        a nucleic acid --> protein interaction in the nucleicAcidInteractions.py file.
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