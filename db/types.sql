--This file contains all the types that will be used across multiple sql files.
drop type if exists interactionInfo;


--=======================GENERAL===========================

--Change the return below to define different separators. Note that this
--separator should match the backend separator as well.
create or replace function
    getSeparator() returns text
as $$
begin
    return '===###==='
end;
$$ language plpgsql;

--======================FOR SEARCH=========================
create type interactionInfo as (
    category    text,
    name        text,
    info        text
);
