#Helper functions for the search.


def handleInteractions(tups):
    ret_list = []
    for tup in tups:
        #Form the name for the keys of the dictionaries first.
        molecule1 = str(tup[2]) + "/" + tup[0] + "/" + tup[1]
        molecule2 = str(tup[5]) + "/" + tup[3] + "/" + tup[4]

        #Below is to find if there is already information logged for molecule1-->molecule2 interactions.
        added = False
        for interactions in ret_list:
            if (molecule1 in interactions.keys()):
                if (molecule2 in interactions.get(molecule1)):
                    #If we reach here, then there was already information about molecule1-->molecule2
                    #Add the extra info on.
                    interactions.get(molecule1).get(molecule2).append(tup[6])
                    added = True
                    break
        if (added):
            continue
        else:
            #If we have no information logged for molecule1-->molecule2, then we make a new record for it.
            interaction_dict = {}
            interaction_dict[molecule1] = {}
            interaction_dict[molecule1][molecule2] = []
            #tup[4] contains the information about the interaction.
            interaction_dict[molecule1][molecule2].append(tup[6])   
            #Interaction_dict is now fully formed. Now we need to decide how to insert this in the ret_list.

        #Check if molecule2 has already been considered in place of a molecule1 before. This is so that we can associate
        #the interactions between molecule1-->molecule2 and molecule2-->molecule1
        added = False
        for interactions in ret_list:
            if (molecule2 in interactions.keys()):
                #Now, check if molecule1 is the second nested key of the key's value from above. 
                # [{DNA Polymerase: {DNA Polymerase III Gene (THIS KEY IS GRABBED IN THIS CASE): }}}]
                #Now, grab the inner dictionary.
                interactionDictInner = interactions.values()
                for interactions2 in interactionDictInner:
                    if (molecule1 in interactions2.keys()):
                        #If the above is true, then that means that the current value in tup considers the reverse
                        #case of the interaction.
                        interactions.update(interaction_dict)
                        added = True
                        break
                if (added):
                    break
        #If we could not find a dictionary that already contains molecule1 or 2, simply add
        #it as a new entry to the list.
        if (not added):
            ret_list.append(interaction_dict)
    return ret_list