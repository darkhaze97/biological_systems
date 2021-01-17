#Helper functions for the search.


def handleInteractions(tups):
    ret_list = []
    for tup in tups:
        interaction_dict = {}
        molecule1 = tup[0] + "/" + tup[1]
        molecule2 = tup[2] + "/" + tup[3]

        interaction_dict[molecule1] = {}
        interaction_dict[molecule1][molecule2] = []

        for i in range(4, len(tup)):
            if (tup[i] == None):
                break;
            interaction_dict[molecule1][molecule2].append(tup[i])
        
        #Interaction_dict is now fully formed. Now we need to decide how to insert this in the ret_list.

        #Check if molecule2 has already been considered in place of a molecule1 before.
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