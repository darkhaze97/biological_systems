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
            from    Molecules m1
                    join Interactions i on (m1.id = i.molecule1_id)
                    join Molecules m2 on (m2.id = i.molecule2_id)
        where m1.id = $1 and m2.id = $2
    loop
        interaction.category = tup.category;
        interaction.name = tup.name;
        interaction.info = tup.info;
        return next interaction;
    end loop;
end
$$ language plpgsql;