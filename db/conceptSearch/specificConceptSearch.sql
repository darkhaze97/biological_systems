--Written by Tim Huang

create or replace function
    specificConceptSearch(id integer) returns setof conceptInfo
as $$
declare
    info conceptInfo;
begin
    select name, info into info.concept_name, info.info
        from    Concepts
    where id = $1
    if (info not null) then
        return next info;
    end if;
end
$$ language plpgsql;

--This function collects all information about other molecules' involvement in
--this concept. This information will be presented as a hyperlink.
create or replace function
    getConceptMolecules() returns setof conceptMoleculeBasicInfo
as $$
declare

begin

end
$$ language plpgsql;