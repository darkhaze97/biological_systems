-- Written by Tim Huang 

-- Self defined types

drop table if exists Protein_Binds_to_Nucleic_Acid;
drop table if exists Protein_cleaves_Nucleic_Acid;
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
    name                    text,
    denatured_by            text,
    origin                  text not null,
    bond_types              text,
    secondary_structure     text,
    tertiary_structure      text,
    quaternary_structure    text, -- This will be null if the protein does not contain any subunit.
    sequence                text not null,
    primary key (name),
    foreign key (sequence) references Sequences(sequence)
);

create table Nucleic_Acids (
    name                    text,
    sequence                Bases not null, 
    origin                  text not null,
    type                    Nucleic_Acid_Types not null,
    hydrolysed_by           text,
    codes_for               text,
    primary key (name),
    foreign key (codes_for) references Proteins(name)
);

create table Protein_Binds_To_Nucleic_Acid (
    protein_name            text,
    nucleic_acid_name       text,
    effect                  text,
    motif                   text not null,
    primary key (protein_name, nucleic_acid_name),
    foreign key (protein_name) references Proteins(name),
    foreign key (nucleic_acid_name) references Nucleic_Acids(name)
);

create table Protein_Cleaves_Nucleic_Acid (
    protein_name            text,
    nucleic_acid_name       text,
    bases                   Bases not null,
    type                    text not null,
    primary key (protein_name, nucleic_acid_name),
    foreign key (protein_name) references Proteins(name),
    foreign key (nucleic_acid_name) references Nucleic_Acids(name)
);

