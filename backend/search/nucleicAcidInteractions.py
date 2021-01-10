"""
    This file helps model nucleic acid interaction with other molecules.
"""

from .searchItemMaker import uniqueMolecules, identicalMolecules

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