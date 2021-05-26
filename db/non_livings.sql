drop table if exists Viruss;
drop table if exists Non_Livings;
drop type if exists Non_Living_Types;
drop type if exists Viral_Nucleic_Acid_Types;

create type Non_Living_Types as enum('Virus');

create type Viral_Nucleic_Acid_Types as enum('DNA', 'RNA');

--Tables/relations:

create table Non_Livings (
    id          serial,
    type        Non_Living_Types,
    primary key (id),
    foreign key (id) references Entities(id)
);

--Note: I put an 's' in front of Virus to represent that it is a plural.
--I am following the convention that I have put in place for all
--table names.
create table Viruss (
    id          serial,
    primary key (id),
    foreign key (id) references Non_Livings(id)
);