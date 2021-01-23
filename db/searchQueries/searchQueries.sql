-- Written by Tim Huang

-- I will create some types that will be the return type of some plpgsql functions.
-- Note that each section only deals with the interaction between molecule1 to molecule2.
-- i.e. there is directionality with this. I am not simply swapping the orientation of molecule1
-- and molecule2

--DIRECTIONALITY

create or replace function
    searchMolecules(name1 text, type1 text, name2 text, type2 text) returns setof nonSpecificInteractionInformation
as $$
declare
    molecule1 record;
    molecule2 record;
    queryString1 text := '';
    queryString2 text := '';
    info record;
begin
    raise notice 'Nooooo';
    --The lines below form the dynamic query based on the type that the user passed in.
    queryString1 = '
                    select id, replace(cast(type as text), '' '', ''_'') as type
                        from    Molecules
                    where name ~* (''^' || $1 || ''')
                  ';
    queryString2 = '
                    select id, replace(cast(type as text), '' '', ''_'') as type
                        from    Molecules
                    where name ~* (''^' || $3 || ''')
                   ';
    --If the user specifies any, then we can search from any molecule type. Therefore, we would not
    --need to care about the type of the molecule. I.e. we do not need to make sure that type ~* 'Protein', for example
    if ($2 !~* '^Any') then
        queryString1 = queryString1 || ' and cast(type as text) ~* ''^' || $2 || '''';
    end if;
    if ($4 !~* '^Any') then
        queryString2 = queryString2 || ' and cast(type as text) ~* ''^' || $4 || '''';
    end if;

    for molecule1 in
        execute queryString1
    loop
        for molecule2 in
            execute queryString2
        loop
            raise notice 'hi';
            for info in
                execute 'select * from ' || molecule1.type || '_' || molecule2.type || '(''' || molecule1.id || ''', ''' || molecule2.id || ''')'
            loop
                return next info;
            end loop;
            --below is the reverse case
            for info in
                execute 'select * from ' || molecule2.type || '_' || molecule1.type || '(''' || molecule2.id || ''', ''' || molecule1.id || ''')'
            loop
                return next info;
            end loop;
        end loop;
    end loop;
end
$$ language plpgsql;