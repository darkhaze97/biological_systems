--Written by Tim Huang

--This file is for searching for MANY concepts at a time (i.e. general search). The user can then define
--the specifics from these returns.

--This function can return more than one Concept. The backend must allow the user to select
--their desired concept.
create or replace function
    searchConcept(name text) returns setof conceptBasicInfo
as $$
declare
    conceptInfo conceptBasicInfo;
    tup record;
begin
    for tup in
        select *
            from    Concepts c
        where c.name ~* ('^' || $1)
    loop
        conceptInfo.concept_id = tup.id;
        conceptInfo.concept_name = tup.name;
        conceptInfo.basic_info = tup.basic_info;
        return next conceptInfo;
    end loop;
end
$$ language plpgsql;