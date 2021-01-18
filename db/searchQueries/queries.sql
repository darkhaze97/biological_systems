-- Written by Tim Huang

-- I will create some types that will be the return type of some plpgsql functions.
-- Note that each section only deals with the interaction between molecule1 to molecule2.
-- i.e. there is directionality with this. I am not simply swapping the orientation of molecule1
-- and molecule2

--DIRECTIONALITY

drop function if exists protein_Nucleic_Acid;
drop function if exists specificProteinNucleicAcid;
drop function if exists nucleicAcidProteinCodesFor;
drop function if exists proteinNucleicAcidProteinCleaves;
drop function if exists nucleic_Acid_Protein;
drop function if exists specificNucleicAcidProtein;
drop function if exists proteinNucleicAcidBindsTo;
drop function if exists protein_Protein;
drop function if exists specificProteinProtein;
drop function if exists nucleic_Acid_Nucleic_Acid;
drop function if exists specificNucleicAcidNucleicAcid;

--====================================PROTEIN | NUCLEIC ACID===============================================

--The function below returns all the interactions that the protein has with the nucleic acid.
create or replace function
    specificProteinNucleicAcid(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare
    interactions nonSpecificInteractionInformation;
begin

    select 'Protein' into interactions.molecule1type;
    select 'Nucleic Acid' into interactions.molecule2type;

    --Check if the protein cleaves the nucleic acid. We pass in the names of
    --the protein and nucleic acid.
    if (proteinNucleicAcidProteinCleaves($1, $2)) then
        interactions.interaction1 = 'protein_cleaves';
    else
        interactions.interaction1 = 'None';
    end if;

    --Check if the protein binds to the nucleic acid.
    if (proteinNucleicAcidBindsTo($1, $2)) then
        interactions.interaction2 = 'protein_binds_to';
    else
        interactions.interaction2 = 'None';
    end if;

    if (interactions.interaction1 = 'protein_cleaves' or interactions.interaction2 = 'protein_binds_to') then
        -- Here, we want to associate the two molecules if there are any
        -- interactions between the molecules.
        select name into interactions.molecule1name
        from    Molecules
        where id = $1 and type = 'Protein';
        select name into interactions.molecule2name
        from    Molecules
        where id = $2 and type = 'Nucleic Acid';
        return next interactions;
    end if;
end;
$$ language plpgsql;

-- The function below returns true if the protein cleaves the nucleic acid.
create or replace function
    proteinNucleicAcidProteinCleaves(id1 integer, id2 integer) returns boolean
as $$
declare
    protein_cleaves_no integer := 0;
begin
    select 1 into protein_cleaves_no
    from    Proteins p
            join Protein_Cleaves_Nucleic_Acid pc on (pc.protein_id = p.id)
            join Nucleic_Acids na on (pc.nucleic_acid_id = na.id)
    where p.id = $1 and na.id = $2;
    if (protein_cleaves_no > 0) then
        return true;
    end if;
    return false;
end
$$ language plpgsql;

-- The function below returns true if the protein binds to the nucleic acid.
create or replace function
    proteinNucleicAcidBindsTo(id1 integer, id2 integer) returns boolean
as $$
declare 
    binds_to_no integer := 0;
begin
    select 1 into binds_to_no
    from    Proteins p
            join Protein_Binds_To_Nucleic_Acid bt on (bt.protein_id = p.id)
            join Nucleic_Acids na on (bt.nucleic_acid_id = na.id)
    where p.id = $1 and na.id = $2;
    if (binds_to_no > 0) then
        return true;
    end if;
    return false;
end
$$ language plpgsql;

--===============================NUCLEIC ACID | PROTEIN====================================

--Note that some of the code is repeated for PROTEIN | NUCLEIC ACID, however, I cannot avoid them
--as the types that I am returning are still different.
create or replace function
    specificNucleicAcidProtein(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare 
    interactions nonSpecificInteractionInformation;
begin
    select 'Nucleic Acid' into interactions.molecule1type;
    select 'Protein' into interactions.molecule2type;

    --Check if the nucleicAcid codes for the protein
    if (nucleicAcidProteinCodesFor($1, $2)) then
        interactions.interaction1 = 'codes_for';
    end if;

    if (interactions.interaction1 = 'codes_for') then
        -- Here, we want to associate the two molecules if there are any
        -- interactions between the molecules.
        select name into interactions.molecule1name
        from    Molecules
        where id = $1 and type = 'Nucleic Acid';
        select name into interactions.molecule2name
        from    Molecules
        where id = $2 and type = 'Protein';
        return next interactions;
    end if;
end
$$ language plpgsql;

--The function below returns true if the nucleic acid codes for the protein.
create or replace function
    nucleicAcidProteinCodesFor(id1 integer, id2 integer) returns boolean
as $$
declare
    codes_for_no integer := 0;
begin
    select 1 into codes_for_no
    from    Proteins p
            join Nucleic_Acids na on (na.codes_for = p.id)
    where p.id = $2 and na.id = $1;
    if (codes_for_no > 0) then
        return true;
    end if;
    return false;
end;
$$ language plpgsql;

--====================================PROTEIN | PROTEIN==========================================

create or replace function
    specificProteinProtein(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare
    interactions nonSpecificInteractionInformation;
begin
    select 'Protein' into interactions.molecule1type;
    select 'Protein' into interactions.molecule2type;
    --Make any checks... Currently, I do not have any interactions between protein --> protein,
    --so I'll leave the if statement below as false
    if (false) then
        select name into interactions.molecule1name
        from    Molecules
        where id = $1;
        select name into interactions.molecule2name
        from    Molecules
        where id = $2;
        return next interactions;
    end if;
end
$$ language plpgsql;

--================================NUCLEIC ACID | NUCLEIC ACID========================================

create or replace function
    specificNucleicAcidNucleicAcid(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare
    interactions nonSpecificInteractionInformation;
begin
    select 'Nucleic Acid' into interactions.molecule1type;
    select 'Nucleic Acid' into interactions.molecule2type;
    --Same as the PROTEIN | PROTEIN case
    if (false) then
        select name into interactions.molecule1name
        from    Molecules
        where id = $1;
        select name into interactions.molecule2name
        from    Molecules
        where id = $2;
        return next interactions;
    end if;
end
$$ language plpgsql;


--=================================CHANGE WHEN ADDING NEW TABLES======================================

--================================PROTEIN | NUCLEIC ACIDS========================================

create or replace function
    protein_Nucleic_Acid(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare
    names record;
begin
    for names in
        select distinct p.id as protein_id, na.id as nucleic_acid_id
        from    Proteins p
                join Protein_Binds_To_Nucleic_Acid bt on (bt.protein_id = p.id)
                join Nucleic_Acids na on (bt.nucleic_acid_id = na.id)
        where p.id = $1 and na.id = $2
        union
        select distinct p.id as protein_id, na.id as nucleic_acid_id
        from    Proteins p
                join Protein_Cleaves_Nucleic_Acid cl on (cl.protein_id = p.id)
                join Nucleic_Acids na on (cl.nucleic_acid_id = na.id)
        where p.id = $1 and na.id = $2
    loop
        return next specificProteinNucleicAcid(names.protein_id, names.nucleic_acid_id);
    end loop;

end;
$$ language plpgsql;

--================================ NUCLEIC ACIDS | PROTEIN ===========================================

create or replace function
    nucleic_Acid_Protein(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare
    names record;
begin
    for names in
        select na.id as nucleic_acid_id, p.id as protein_id
        from    Nucleic_Acids na 
                join Proteins p on (p.id = na.codes_for)
        where na.id = $1 and p.id = $2
    loop
        return next specificNucleicAcidProtein(names.nucleic_acid_id, names.protein_id);
    end loop;
end;
$$ language plpgsql;

--==============================PROTEIN | PROTEIN===================================

create or replace function
    protein_Protein(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare

begin
    
end
$$ language plpgsql;

--=========================NUCLEIC ACID | NUCLEIC ACID================================

create or replace function
    nucleic_Acid_Nucleic_Acid(id1 integer, id2 integer) returns setof nonSpecificInteractionInformation
as $$
declare

begin
    
end
$$ language plpgsql;