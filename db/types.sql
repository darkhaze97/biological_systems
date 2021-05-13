--This file contains all the types that will be used across multiple sql files.
drop type if exists interactionInfo cascade;
drop type if exists nonSpecificInteractionInformation cascade;
drop type if exists conceptMoleculeInfo cascade;
drop type if exists conceptInfo cascade;
drop type if exists conceptMoleculeBasicInfo cascade;
drop type if exists conceptBasicInfo cascade;


--=======================GENERAL===========================

--Change the return below to define different separators. Note that this
--separator should match the backend separator as well.
create or replace function
    getSeparator() returns text
as $$
begin
    return '===###===';
end
$$ language plpgsql;

--======================FOR SEARCH=========================
create type interactionInfo as (
    category    text,
    name        text,
    info        text
);

create type nonSpecificInteractionInformation as (
    molecule1name       text,
    molecule1uppertype  text,
    molecule1type       text,
    molecule1id         integer,
    molecule2name       text,
    molecule2uppertype  text,
    molecule2type       text,
    molecule2id         integer,
    interaction_info    text

    --The upper type refers to the type of entity that the entity belongs to. (E.g. Molecules, Living, Non-living)

    --More can be added depending on max(interactions molecules can have with each other)
    --This will not affect our database schema. It will only affect the functions in the database.
);

--==================FOR CONCEPT==========================
create type conceptMoleculeInfo as (
    molecule_name       text,
    concept_name        text,
    info                text
);

create type conceptInfo as (
    concept_name        text,
    info                text
);

--Id is included in the type below, so that the user can select a specific
--concept.
create type conceptBasicInfo as (
    concept_id          text,
    concept_name        text,
    basic_info          text
);

--Molecule id is included below so that the user can select a specific molecule with a 
--concept.
create type conceptMoleculeBasicInfo as (
    molecule_id         integer,
    molecule_name       text,
    basic_info          text
);
