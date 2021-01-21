--Written by Tim Huang

create or replace function
    searchOneMolecule(name1 text, type1 text) returns setof nonSpecificInteractionInformation
as $$
declare
    molecule1 record;
    molecule2 record;
    info record;
begin

    select id, replace(cast(type as text), ' ', '_') as type into molecule1
    from    Molecules
    where cast(type as text) ~* ('^' || type1) and name ~* ('^' || name1);

    for molecule2 in
        select id, replace(cast(type as text), ' ', '_') as type
        from    Molecules
    loop
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



end
$$ language plpgsql;