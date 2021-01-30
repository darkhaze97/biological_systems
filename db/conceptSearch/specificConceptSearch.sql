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
    getConceptMolecules(id integer) returns setof conceptMoleculeBasicInfo
as $$
declare
    info conceptMoleculeBasicInfo;
    tup record;
begin
    for tup in
        select c.name as concept_name, m.id, m.name as molecule_name, i.info
            from    Concepts c
                    join Incorporates i on (i.concept_id = c.id)
                    join Molecules m on (i.molecule_id = m.id)
        where c.id = $1
    loop
        info.concept_name = tup.concept_name;
        info.molecule_id = tup.id;
        info.molecule_name = tup.molecule_name;
        info.basic_info = tup.info;
        return next info;
    end loop;
end
$$ language plpgsql;

create or replace function
    specificConceptMoleculeSearch(id integer) returns setof conceptMoleculeInfo
as $$
declare
    info conceptMoleculeInfo;
    tup record;
begin
    for tup in
        select c.name as concept_name, i.info, m.name as molecule_name
            from    Concepts c
                    join Incorporates i on (i.concept_id = c.id)
                    join Molecules m on (m.id = i.molecule_id)
        where c.id = $1
    loop
        info.concept_name = tup.concept_name;
        info.molecule_name = tup.molecule_name;
        info.info = tup.info;
        return next info;
    end loop;
end
$$ language plpgsql;