-- Written by Tim Huang

-- I will create some types that will be the return type of some plpgsql functions.
-- Note that each section only deals with the interaction between molecule1 to molecule2.
-- i.e. there is directionality with this. I am not simply swapping the orientation of molecule1
-- and molecule2

--DIRECTIONALITY

create or replace function
    searchTwoMolecules(name1 text, type1 text, name2 text, type2 text) returns setof nonSpecificInteractionInformation
as $$
declare
    molecule1 record;
    molecule2 record;
    queryString1 text := '';
    queryString2 text := '';
    info record;
begin

    queryString1 = '
                    select name, cast(type as text) as type
                        from    Molecules
                    where name like (''' || $1 || '%'')
                  ';
    queryString2 = '
                    select name, cast(type as text) as type
                        from    Molecules
                    where name like (''' || $3 || '%'')
                   ';
    if ($2 != 'Any') then
        queryString1 = queryString1 || ' and cast(type as text) = ''' || $2 || '''';
    end if;
    if ($4 != 'Any') then
        queryString2 = queryString2 || ' and cast(type as text) = ''' || $4 || '''';
    end if;

    for molecule1 in
        execute queryString1
    loop
        for molecule2 in
            execute queryString2
        loop
            raise notice 'Hi';
            select replace(molecule2.type, ' ', '_') into molecule2.type;
            select replace(molecule1.type, ' ', '_') into molecule1.type;
            for info in
                execute 'select * from ' || molecule1.type || '_' || molecule2.type || '(''' || molecule1.name || ''', ''' || molecule2.name || ''')'
            loop
                return next info;
            end loop;
            --below is the reverse case
            for info in
                execute 'select * from ' || molecule2.type || '_' || molecule1.type || '(''' || molecule2.name || ''', ''' || molecule1.name || ''')'
            loop
                return next info;
            end loop;
        end loop;
    end loop;
end
$$ language plpgsql;