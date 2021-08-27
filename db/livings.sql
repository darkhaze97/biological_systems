drop table if exists Bacterias;
drop table if exists Livings;
drop type if exists Living_Types;
drop type if exists GramReaction;

create type Living_Types as enum('Bacteria', 'Fungi', 'Eukaryote');

create type GramReaction as enum('Positive', 'Negative', 'Not Applicable');

--Tables/relations:

create table Livings (
    id          serial,
    type        Living_Types,
    taxonomy    text,
    primary key (id),
    foreign key (id) references Entities(id)
);

create table Bacterias (
    id                  serial,
    gram_reaction       GramReaction,
    primary key (id),
    foreign key (id) references Livings(id)
);