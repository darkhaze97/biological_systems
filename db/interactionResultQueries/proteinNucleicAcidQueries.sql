--This file is to grab all the information about the interactions between
--two molecules after a search has been completed.

drop function if exists getProteinNucleicAcidInteractionDetail;
drop type if exists interactionInfo;


create type interactionInfo as (
    category    text,
    name        text,
    info        text
);

--==========================PROTEIN | NUCLEIC ACID============================

--I am assuming $1 is the protein, and $2 is the nucleic acid.
create or replace function
    getProteinNucleicAcidInteractionDetail(name1 text, name2 text) returns setof interactionInfo
as $$
declare
    interaction interactionInfo;
    tup record;
begin
    --First, do the codes for.
    for tup in
        select *
            from    Proteins p
                    join Nucleic_Acids na on (na.codes_for = p.name)
        where p.name = $1 and na.name = $2
    loop
        interaction.category = 'Coding';
        interaction.name = $2 || ' codes for ' || $1;
        interaction.info = $2 || ' codes for ' || $1;
        return next interaction;
    end loop;

    --Find the interactions for binds to.
    for tup in
        select bt.effect, bt.motif
            from    Proteins p
                    join Protein_Binds_To_Nucleic_Acid bt on (bt.protein_name = p.name)
                    join Nucleic_Acids na on (bt.nucleic_acid_name = na.name)
        where p.name = $1 and na.name = $2
    loop
        interaction.category = 'Protein binding';
        interaction.name = $1 || ' binds to ' || $2;
        interaction.info = 'effect: ' || tup.effect || '===###===motif: ' || tup.motif;
        return next interaction;
    end loop;

    --Find the interactions for cleaves.
    for tup in
        select cl.bases, cl.type
            from    Proteins p
                    join Protein_Cleaves_Nucleic_Acid cl on (cl.protein_name = p.name)
                    join Nucleic_Acids na on (cl.nucleic_acid_name = na.name)
        where p.name = $1 and na.name = $2
    loop
        interaction.category = 'Protein cleaving';
        interaction.name = $1 || ' cleaves ' || $2;
        interaction.info = 'bases cleaved: ' || tup.bases || '===###===type: ' || tup.type;
        return next interaction;
    end loop;

end
$$ language plpgsql;