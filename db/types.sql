--This file contains all the types that will be used across multiple sql files.
drop type if exists interactionInfo;

--======================FOR SEARCH=========================
create type interactionInfo as (
    category    text,
    name        text,
    info        text
);