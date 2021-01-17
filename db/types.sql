--This file contains all the types that will be used across multiple sql files.
drop type if exists interactionInfo cascade;
drop type if exists nonSpecificInteractionInformation cascade;


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
    molecule1type       text,
    molecule2name       text,
    molecule2type       text,
    interaction1        text,
    interaction2        text,
    interaction3        text
    --More can be added depending on max(interactions molecules can have with each other)
    --This will not affect our database schema. It will only affect the functions in the database.
);