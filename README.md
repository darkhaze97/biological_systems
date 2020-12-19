# biological_systems

Modelling Biological Systems
User stories:
- As a student/researcher, I want to be able to search for interactions with a specific molecule in order to find out more about interactions with that molecule.
  Acceptance criteria:
        - We can input a specific molecule, and it will be matched with other molecules it interacts
          with. It then outputs to the user to read. Here, an index will be given to a user (if there
          is more than one interaction with that molecule) and the user can choose which one to read
          about.
        - We can input two molecules to find that specific interaction.
- As a student/researcher I want to be able to find out characteristics for the molecule, in order to become aware
  of the nature of it (and therefore use it for future research to find other molecules, create other molecules, etc.)
  Acceptance criteria:
        - Upon selecting a specific interaction, the user will be able to view information about the two molecules independently: We will be able to see the molecule, other similar molecules, etc.
        - The information should be very minimalistic: Dot pointed, minimal text, mainly diagrammatic representation? (For the frontend only really...)
- As a researcher, I want to be able to view articles about the two molecules in order to inform my
  current research by comparing with other researchers.
  Acceptance criteria:
        - A user should be able to see what articles are available for the two molecules, including the date published, title, etc. and be able to click on it. Clicking on the link should lead to a new page with the article. (Must be the free version, I do not support piracy!)
  Implementation:
        - Is there an API that holds all information about all articles?
- As a user, I want to be able to select different options to narrow my search to a specific class of molecules, so that my results will be reduced in size.
  Acceptance criteria:
      - A user should be able to click something that selects a specific type of molecule. This should be passed downward into the backend.
- As a user, I want to be able to only type in a section of a molecule's name to see what molecules match that name, in case I had forgotten the molecule's exact name.
  Acceptance criteria:
      - The results will return similar to the first user story. However, the name that was matched will have (in red) the pattern that the user entered


Possible extensions:
- Able to click on an amino acid to see what type of interactions it has?


SQL database entity attributes
- Cell/cell location it is found in
- Molecule type (already known, by looking at entity attribute)
- Molecule specific:
    - Proteins: Amino acid sequence, coded by which gene sequence?
    - Carbohydrate: Dissacharide, energy given
    - Fat: Trans, etc.
    - Nucleic acids: tRNA