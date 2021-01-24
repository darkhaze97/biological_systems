-- Written by Tim Huang

-- I will create some types that will be the return type of some plpgsql functions.
-- Note that each section only deals with the interaction between molecule1 to molecule2.
-- i.e. there is directionality with this. I am not simply swapping the orientation of molecule1
-- and molecule2

--DIRECTIONALITY

create or replace function
    createNonSpecificInteractionInformation(name1 text, type1 text, id1 integer, 
                                            name2 text, type2 text, id2 integer,
                                            info text) returns nonSpecificInteractionInformation
as $$
declare
    interactions nonSpecificInteractionInformation;
begin
    interactions.molecule1name = name1;
    interactions.molecule1type = type1;
    interactions.molecule1id = id1;
    interactions.molecule2name = name2;
    interactions.molecule2type = type2;
    interactions.molecule2id = id2;
    interactions.interaction_info = info;
    return interactions;
end
$$ language plpgsql;

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

    --First, attempt to connect the names and types of the molecules based on if they have any interactions between them.
    queryString1 = '
                    select m1.name as m1_name, cast(m1.type as text) as m1_type, m1.id as m1_id,
                           m2.name as m2_name, cast(m2.type as text) as m2_type, m2.id as m2_id,
                           i.category as category
                    from    Molecules m1
                            join Interactions i on (i.molecule1_id = m1.id)
                            join Molecules m2 on (i.molecule2_id = m2.id)
                    where m1.name ~* (''^' || $1 || ''') and m2.name ~* (''^' || $3 || ''')
                   ';
    queryString2 = '
                    select m1.name as m1_name, cast(m1.type as text) as m1_type, m1.id as m1_id,
                           m2.name as m2_name, cast(m2.type as text) as m2_type, m2.id as m2_id,
                           i.category as category
                    from    Molecules m1
                            join Interactions i on (i.molecule1_id = m1.id)
                            join Molecules m2 on (i.molecule2_id = m2.id)
                    where m1.name ~* (''^' || $3 || ''') and m2.name ~* (''^' || $1 || ''')
                   ';

    if ($2 !~* '^Any') then
        queryString1 = queryString1 || ' and cast(m1.type as text) ~* ''^' || $2 || '''';
        queryString2 = queryString2 || ' and cast(m1.type as text) ~* ''^' || $4 || '''';
    end if;
    if ($4 !~* '^Any') then
        queryString1 = queryString1 || ' and cast(m2.type as text) ~* ''^' || $4 || '''';
        queryString2 = queryString2 || ' and cast(m2.type as text) ~* ''^' || $2 || '''';
    end if;

    for info in
        execute queryString1
    loop
        return next createNonSpecificInteractionInformation(info.m1_name, info.m1_type, info.m1_id, info.m2_name, info.m2_type, info.m2_id, info.category);
    end loop;

    for info in
        execute queryString2
    loop
        return next createNonSpecificInteractionInformation(info.m1_name, info.m1_type, info.m1_id, info.m2_name, info.m2_type, info.m2_id, info.category);
    end loop;
end
$$ language plpgsql;
