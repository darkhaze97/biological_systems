-- Written by Tim Huang

-- I will create some types that will be the return type of some plpgsql functions.
-- Note that each section only deals with the interaction between entity1 to entity2.
-- i.e. there is directionality with this. I am not simply swapping the orientation of entity1
-- and entity2

--DIRECTIONALITY

create or replace function
    createNonSpecificInteractionInformation(name1 text, type1 text, id1 integer, 
                                            name2 text, type2 text, id2 integer,
                                            info text) returns nonSpecificInteractionInformation
as $$
declare
    interactions nonSpecificInteractionInformation;
begin
    interactions.entity1name = name1;
    interactions.entity1type = type1;
    interactions.entity1id = id1;
    interactions.entity2name = name2;
    interactions.entity2type = type2;
    interactions.entity2id = id2;
    interactions.interaction_info = info;
    return interactions;
end
$$ language plpgsql;

create or replace function
    searchInteractions(name1 text, type1 text, name2 text, type2 text) returns setof nonSpecificInteractionInformation
as $$
declare
    entity1 record;
    entity2 record;
    queryString1 text := '';
    queryString2 text := '';
    info record;
    --Entity1/2_type holds the 'deeper' type of the entity. If the entity is a molecule, then this variable
    --will hold either a 'Protein', 'Nucleic Acid', etc.
    entity1_type text := '';
    entity2_type text := '';
begin
    --First, attempt to connect the names and types of the molecules based on if they have any interactions between them.
    --For now, I will set the entity type as from the entities.sql file. Later on, I will make it's type from the molecules.sql 
    --file, or the living.sql file.
    queryString1 = '
                    select e1.name as e1_name, cast(e1.type as text) as e1_type, e1.id as e1_id,
                           e2.name as e2_name, cast(e2.type as text) as e2_type, e2.id as e2_id,
                           e_i.category as category
                    from    Entities e1
                            join Entity_Interactions e_i on (e_i.entity1_id = e1.id)
                            join Entities e2 on (e_i.entity2_id = e2.id)
                    where e1.name ~* (''^' || $1 || ''') and e2.name ~* (''^' || $3 || ''')
                   ';

    queryString2 = '
                    select e1.name as e1_name, cast(e1.type as text) as e1_type, e1.id as e1_id,
                           e2.name as e2_name, cast(e2.type as text) as e2_type, e2.id as e2_id,
                           e_i.category as category
                    from    Entities e1
                            join Entity_Interactions e_i on (e_i.entity1_id = e1.id)
                            join Entities e2 on (e_i.entity2_id = e2.id)
                    where e1.name ~* (''^' || $3 || ''') and e2.name ~* (''^' || $1 || ''')
                   ';

    if ($2 !~* '^Any') then
        queryString1 = queryString1 || ' and cast(e1.type as text) ~* ''^' || $2 || '''';
        queryString2 = queryString2 || ' and cast(e2.type as text) ~* ''^' || $2 || '''';
    end if;
    if ($4 !~* '^Any') then
        queryString1 = queryString1 || ' and cast(e2.type as text) ~* ''^' || $4 || '''';
        queryString2 = queryString2 || ' and cast(e1.type as text) ~* ''^' || $4 || '''';
    end if;

    for info in
        execute queryString1
    loop
        --The execute statements get the lower type of the entity. E.g. for a molecule, if it is a protein, then grab the string: 'Protein'.
        execute 'select e_type.type
                 from ' || info.e1_type || 's e_type where ' || cast(info.e1_id as int) || ' = e_type.id' into entity1_type;
        execute 'select e_type.type
                 from ' || info.e2_type || 's e_type where ' || cast(info.e2_id as int) || ' = e_type.id' into entity2_type;
        return next createNonSpecificInteractionInformation(info.e1_name, entity1_type, info.e1_id, info.e2_name, entity2_type, info.e2_id, info.category);
    end loop;

    for info in
        execute queryString2
    loop
        --The execute statements get the lower type of the entity. E.g. for a molecule, if it is a protein, then grab the string: 'Protein'.
        execute 'select e_type.type
                 from ' || info.e1_type || 's e_type where ' || cast(info.e1_id as int) || ' = e_type.id' into entity1_type;
        execute 'select e_type.type
                 from ' || info.e2_type || 's e_type where ' || cast(info.e2_id as int) || ' = e_type.id' into entity2_type;

        return next createNonSpecificInteractionInformation(info.e1_name, entity1_type, info.e1_id, info.e2_name, entity2_type, info.e2_id, info.category);
    end loop;
end
$$ language plpgsql;