-- Written by Tim Huang 

-- Self defined types

drop table if exists Binds_to;
drop table if exists Protein_cleaves;
drop table if exists Nucleic_Acids;
drop table if exists Proteins;
drop table if exists Sequences;
drop type if exists Nucleic_Acid_Types;
drop domain if exists Bases;

create type Nucleic_Acid_Types as enum ('RNA', 'DNA'); -- I can add more later.
create domain Bases as text check (value ~ ('[AGCUT]{' || cast(char_length(value) as text) || '}'));
-- Above checks whether the sequence has anything other than A, G, C, U or T (the 'normal' bases in DNA/RNA)

-- Create the molecule tables first, THEN create the relationship tables between them to ensure
-- that all the tables are correctly loaded into the database.

create table Sequences (
    sequence                text,
    residue_no              integer not null,
    primary key (sequence)
);

create table Proteins (
    id                      serial,
    name                    text not null,
    denatured_by            text,
    origin                  text not null,
    bond_types              text,
    secondary_structure     text,
    tertiary_structure      text,
    quaternary_structure    text, -- This will be null if the protein does not contain any subunit.
    sequence                text not null,
    primary key (id),
    foreign key (sequence) references Sequences(sequence)
);

create table Nucleic_Acids (
    id                      serial,
    name                    text not null,
    sequence                Bases not null, 
    origin                  text not null,
    type                    Nucleic_Acid_Types not null,
    hydrolysed_by           text,
    codes_for               serial,
    primary key (id),
    foreign key (codes_for) references Proteins(id)
);

create table Binds_to (
    protein_id              serial,
    nucleic_acid_id         serial,
    effect                  text,
    motif                   text not null,
    primary key (protein_id, nucleic_acid_id),
    foreign key (protein_id) references Proteins(id),
    foreign key (nucleic_acid_id) references Nucleic_Acids(id)
);

create table Protein_cleaves (
    protein_id              serial,
    nucleic_acid_id         serial,
    bases                   Nucleic_Acid_Types not null,
    type                    text not null,
    primary key (protein_id, nucleic_acid_id),
    foreign key (protein_id) references Proteins(id),
    foreign key (nucleic_acid_id) references Nucleic_Acids(id)
);

