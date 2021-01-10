--This file is to grab all the information about the interactions between
--two molecules after a search has been completed.


drop function if exists getNucleicAcidNucleicAcidInteractionDetail;

--=======================PROTEIN | PROTEIN===========================
create or replace function
    getNucleicAcidNucleicAcidInteractionDetail(name1 text, name2 text) returns setof interactionInfo
as $$
declare
    tup record;
begin
    
end
$$ language plpgsql;