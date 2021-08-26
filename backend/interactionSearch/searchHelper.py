#Helper functions for the search.

#
def handleInteractions(tups):
    ret_list = []
    for tup in tups:
        #Form the name for the keys of the dictionaries first.
        entity1 = str(tup[2]) + "/" + tup[0] + "/" + tup[1]
        entity2 = str(tup[5]) + "/" + tup[3] + "/" + tup[4]

        #Below is to find if there is already information logged for entity1-->entity2 interactions.
        added = False
        for interactions in ret_list:
            if (entity1 in interactions.keys()):
                if (entity2 in interactions.get(entity1)):
                    #If we reach here, then there was already information about entity1-->entity2
                    #Add the extra info on.
                    interactions.get(entity1).get(entity2).append(tup[6])
                    added = True
                    break
        if (added):
            continue
        else:
            #If we have no information logged for entity1-->entity2, then we make a new record for it.
            interaction_dict = {}
            interaction_dict[entity1] = {}
            interaction_dict[entity1][entity2] = []
            #tup[4] contains the information about the interaction.
            interaction_dict[entity1][entity2].append(tup[6])   
            #Interaction_dict is now fully formed. Now we need to decide how to insert this in the ret_list.

        #Check if entity2 has already been considered in place of an entity1 before. This is so that we can associate
        #the interactions between entity1-->entity2 and entity2-->entity1
        added = False
        for interactions in ret_list:
            if (entity2 in interactions.keys()):
                #Now, check if entity1 is the second nested key of the key's value from above. 
                # [{DNA Polymerase: {DNA Polymerase III Gene (THIS KEY IS GRABBED IN THIS CASE): }}}]
                #Now, grab the inner dictionary.
                interactionDictInner = interactions.values()
                for interactions2 in interactionDictInner:
                    if (entity1 in interactions2.keys()):
                        #If the above is true, then that means that the current value in tup considers the reverse
                        #case of the interaction. Group this interaction together with the previous
                        #one. This is to allow differentiation of entities that interact with
                        #each other.
                        interactions.update(interaction_dict)
                        added = True
                        break
                if (added):
                    break
        #If we could not find a dictionary that already contains entity1 or 2, simply add
        #it as a new entry to the list.
        if (not added):
            ret_list.append(interaction_dict)
    return ret_list