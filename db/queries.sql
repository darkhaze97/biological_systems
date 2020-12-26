-- Written by Tim Huang

-- I will create some types that will be the return type of some plpgsql functions.

drop function if exists proteinNucleicAcid;
drop function if exists proteinNucleicAcidCodesFor;
drop function if exists proteinNucleicAcidProteinCleaves;
drop function if exists nucleicAcidProtein;
drop function if exists proteinNucleicAcidBindsTo;
drop type if exists proteinNucleicAcidInteractions;
drop type if exists nucleicAcidProteinInteractions;

--This type represents protein --> nucleic acid interactions
create type proteinNucleicAcidInteractions as (
    protein         text,
    protein_id      integer,
    nucleic_acid    text,
    nucleic_acid_id integer,
    binds_to        boolean,
    protein_cleaves boolean
);

--====================================PROTEIN | NUCLEIC ACID===============================================

--The function below returns all the interactions that the protein has with the nucleic acid.
create or replace function
    proteinNucleicAcid(name1 text, name2 text) returns setof proteinNucleicAcidInteractions
as $$
declare
    interactions proteinNucleicAcidInteractions;
begin
    --Check if the protein cleaves the nucleic acid.
    interactions.protein_cleaves = proteinNucleicAcidProteinCleaves($1, $2);

    --Check if the protein binds to the nucleic acid.
    interactions.binds_to = proteinNucleicAcidBindsTo($1, $2);

    if (interactions.binds_to = true or interactions.protein_cleaves = true) then
        -- Here, we want to associate the names with the id's if there are any
        -- interactions between the molecules.
        select name, id into interactions.protein, interactions.protein_id
        from    Proteins
        where name = $1;
        select name, id into interactions.nucleic_acid, interactions.nucleic_acid_id
        from    Nucleic_Acids
        where name = $2;
        return next interactions;
    end if;
end;
$$ language plpgsql;

-- The function below returns true if the protein cleaves the nucleic acid.
create or replace function
    proteinNucleicAcidProteinCleaves(name1 text, name2 text) returns boolean
as $$
declare
    protein_cleaves_no integer := 0;
begin
    select 1 into protein_cleaves_no
    from    Proteins p
            join Protein_cleaves pc on (pc.protein_id = p.id)
            join Nucleic_Acids na on (pc.nucleic_acid_id = na.id)
    where p.name = $1 and na.name = $2;
    if (protein_cleaves_no > 0) then
        return true;
    end if;
    return false;
end
$$ language plpgsql;

-- The function below returns true if the protein binds to the nucleic acid.
create or replace function
    proteinNucleicAcidBindsTo(name1 text, name2 text) returns boolean
as $$
declare 
    binds_to_no integer := 0;
begin
    select 1 into binds_to_no
    from    Proteins p
            join Binds_to bt on (bt.protein_id = p.id)
            join Nucleic_Acids na on (bt.nucleic_acid_id = na.id)
    where p.name = $1 and na.name = $2;
    if (binds_to_no > 0) then
        return true;
    end if;
    return false;
end
$$ language plpgsql;

--===============================NUCLEIC ACID | PROTEIN====================================

--This type represents nucleic acids --> protein interactions
create type nucleicAcidProteinInteractions as (
    nucleic_acid    text,
    nucleic_acid_id integer,
    protein         text,
    protein_id      text,
    codes_for       boolean
);

--Note that some of the code is repeated for PROTEIN | NUCLEIC ACID, however, I cannot avoid them
--as the types that I am returning are still different.
create or replace function
    nucleicAcidProtein(name1 text, name2 text) returns setof nucleicAcidProteinInteractions
as $$
declare 
    interactions nucleicAcidProteinInteractions;
begin
    --Check if the nucleicAcid codes for the protein
    interactions.codes_for = proteinNucleicAcidCodesFor($1, $2);

    if (interactions.codes_for = true) then
        -- Here, we want to associate the names with the id's if there are any
        -- interactions between the molecules.
        select name, id into interactions.protein, interactions.protein_id
        from    Proteins
        where name = $1;
        select name, id into interactions.nucleic_acid, interactions.nucleic_acid_id
        from    Nucleic_Acids
        where name = $2;
        return next interactions;
    end if;
end
$$ language plpgsql;

--The function below returns true if the nucleic acid codes for the protein.
create or replace function
    proteinNucleicAcidCodesFor(name1 text, name2 text) returns boolean
as $$
declare
    codes_for_no integer := 0;
begin
    select 1 into codes_for_no
    from    Proteins p
            join Nucleic_Acids na on (na.codes_for = p.id)
    where p.name = $1 and na.name = $2;
    if (codes_for_no > 0) then
        return true;
    end if;
    return false;
end;
$$ language plpgsql;
