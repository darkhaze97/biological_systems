--Written by Tim Huang

create or replace function
    getSpecificInteraction(id1 integer, id2 integer) returns setof interactionInfo
as $$
declare
    interaction interactionInfo;
    tup record;
begin

    --First, connect the interactions of the two molecules....

    for tup in
        select *
            from    Entities e1
                    join Entity_Interactions ei on (e1.id = ei.entity1_id)
                    join Entities e2 on (e2.id = ei.entity2_id)
        where e1.id = $1 and e2.id = $2
    loop
        interaction.category = tup.category;
        interaction.name = tup.name;
        interaction.info = tup.info;
        return next interaction;
    end loop;
end
$$ language plpgsql;

create or replace function
    getUpperType(id1 integer) returns text
as $$
    select cast(type as text)
    from    Entities
    where id1 = id
$$ language sql;