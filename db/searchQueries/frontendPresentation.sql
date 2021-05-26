--This file is mainly for queries that allow the frontend to present data in the db.
--E.g. the frontend can obtain the types of entities that are available to search.

create or replace function
    obtainEntityTypes() returns setof text
as $$
declare
    etype text := '';
    lowerTypeEnum text := '';
    lowerTypeQuery text := '';
    lowerType text := '';
    --Note: lowertype obtains the lower type of the entity.
begin
    --Obtain top level first.
    for etype in
        select * from unnest(enum_range(NULL::Entity_Types))
    loop
        lowerTypeEnum = etype || '_Types';
        --Edit lowerTypeEnum such that all spaces or '-' are edited out
        --and replaced with '-'
        select * into lowerTypeEnum from replace(lowerTypeEnum, ' ', '_');
        select * into lowerTypeEnum from replace(lowerTypeEnum, '-', '_');
        --Now, lowertype contains something like: Molecule_Types, which is
        --an enum. We will create a dynamic query to obtain the lower types.
        lowerTypeQuery = 'select * from unnest(enum_range(NULL::' || lowerTypeEnum || '))';
        --Now, loop through the returns of the query.
        for lowerType in
            execute lowerTypeQuery
        loop
            return next etype || '-' || lowerType;
        end loop;

        return next etype;
    end loop;
end
$$ language plpgsql;
