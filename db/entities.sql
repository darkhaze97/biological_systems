drop table if exists Entity_Interactions;
drop table if exists Entities;
drop type if exists Entity_Types;

create type Entity_Types as enum('Molecule', 'Living', 'Non-Living');

create table Entities (
    id              serial,
    name            text,
    type            Entity_Types,
    primary key (id)
);

create table Entity_Interactions (
    entity1_id      integer,
    entity2_id      integer,
    category        text not null,
    name            text not null,
    info            text not null,
    primary key (entity1_id, entity2_id, category),
    foreign key (entity1_id) references Entities(id),
    foreign key (entity2_id) references Entities(id)
);