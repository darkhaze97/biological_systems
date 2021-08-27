-- This file is simply to make tables that help in retrieving concept data.

drop table if exists Incorporates;

create table Incorporates (
    concept_id              integer,
    entity_id               integer,
    basic_info              text,
    info                    text,
    primary key (concept_id, entity_id),
    foreign key (concept_id) references Concepts(id),
    foreign key (entity_id) references Concepts(id)
);