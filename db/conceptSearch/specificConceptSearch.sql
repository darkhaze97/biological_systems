--Written by Tim Huang

--These are all functions that help produce the page about ONE specific concept.

create or replace function
    specificConceptSearch(id integer) returns setof conceptInfo
as $$
declare
    info conceptInfo;
begin
    select c.name, c.info into info.concept_name, info.info
        from    Concepts c
    where c.id = $1;
    if (info is not null) then
        return next info;
    end if;
end
$$ language plpgsql;

--This function collects all information about other molecules' involvement in
--this concept. This information will be presented as a hyperlink.
--id contains the id of the concept that the user is looking at.
create or replace function
    getConceptEntities(id integer) returns setof conceptEntityBasicInfo
as $$
declare
    info conceptEntityBasicInfo;
    tup record;
begin
    for tup in
        select c.name as concept_name, e.id, e.name as entity_name, i.info
            from    Concepts c
                    join Incorporates i on (i.concept_id = c.id)
                    join Entities e on (i.entity_id = e.id)
        where c.id = $1
    loop
        info.entity_id = tup.id;
        info.entity_name = tup.entity_name;
        info.basic_info = tup.info;
        return next info;
    end loop;
end
$$ language plpgsql;

create or replace function
    specificConceptEntitySearch(id integer) returns setof conceptEntityInfo
as $$
declare
    info conceptEntityInfo;
    tup record;
begin
    for tup in
        select c.name as concept_name, i.info, e.name as entity_name
            from    Concepts c
                    join Incorporates i on (i.concept_id = c.id)
                    join Entities m on (e.id = i.entity_id)
        where c.id = $1
    loop
        info.concept_name = tup.concept_name;
        info.entity_name = tup.entity_name;
        info.info = tup.info;
        return next info;
    end loop;
end
$$ language plpgsql;