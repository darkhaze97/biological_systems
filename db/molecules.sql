-- Written by Tim Huang 

-- Self defined types

drop table if exists Protein_Binds_to_Nucleic_Acid;
drop table if exists Protein_cleaves_Nucleic_Acid;
drop table if exists Protein_Synthesises_Carbohydrate;
drop table if exists Protein_Synthesises_Lipid;
drop table if exists Protein_Subunit_For_Protein;
drop table if exists Nucleic_Acids;
drop table if exists Proteins;
drop table if exists Sequences;
drop table if exists Lipids;
drop table if exists Hormones;
drop table if exists Carbohydrates;
drop table if exists Interactions;
drop table if exists Molecules;
drop type if exists Nucleic_Acid_Types;
drop type if exists Molecule_Types;
drop domain if exists Bases;
drop type if exists Lipid_Types;
drop type if exists Hormone_Types;
drop type if exists Carbohydrate_Chiralities;

create type Molecule_Types as enum('Protein', 'Nucleic Acid', 'Lipid', 'Carbohydrate');

--Below are for Nucleic_Acids
create type Nucleic_Acid_Types as enum ('RNA', 'DNA'); -- I can add more later.
create domain Bases as text check (value ~ ('[AGCUT]{' || cast(char_length(value) as text) || '}'));
-- Above checks whether the sequence has anything other than A, G, C, U or T (the 'normal' bases in DNA/RNA)

--Below is for Lipids
create type Lipid_Types as enum('Monounsaturated', 'Saturated', 'Trans', 'Polyunsaturated', 'Multimolecular');

--Below is for Carbohydrates
create type Carbohydrate_Chiralities as enum('D', 'L');

--Below is for Hormones
create type Hormone_Types as enum('Steroid', 'Peptide', 'Amine', 'Eicosanoid');

-- Create the molecule tables first, THEN create the relationship tables between them to ensure
-- that all the tables are correctly loaded into the database.

create table Molecules (
    id                      serial,
    type                    Molecule_Types,
    primary key (id)
);

create table Sequences (
    sequence                text,
    residue_no              integer not null,
    primary key (sequence)
);

create table Proteins (
    id                      integer,
    denatured_by            text,
    origin                  text not null,
    bond_types              text,
    secondary_structure     text,
    tertiary_structure      text,
    quaternary_structure    text, -- This will be null if the protein does not contain any subunit.
    sequence                text not null,
    primary key (id),
    foreign key (id) references Molecules(id),
    foreign key (sequence) references Sequences(sequence)
);

create table Nucleic_Acids (
    id                      integer,
    sequence                Bases not null, 
    origin                  text not null,
    nucleic_acid_type       Nucleic_Acid_Types not null,
    hydrolysed_by           text,
    primary key (id),
    foreign key (id) references Molecules(id)
);

create table Lipids (
    id                      integer,
    type                    Lipid_Types,
    energy                  text,
    component               text, --This will list what is in the molecule... E.g. for a triacyglyceride, it will be glycerol, and 3x fatty acid chain
    primary key (id),
    foreign key (id) references Molecules(id)
);

create table Hormones (
    id                      integer,
    type                    Hormone_Types,
    origin                  text,
    primary key (id),
    foreign key (id) references Molecules(id)
);

create table Carbohydrates (
    id                      integer,
    chirality               Carbohydrate_Chiralities,
    carbon_no               integer,
    energy                  text,
    primary key (id),
    foreign key (id) references Molecules(id)
);

create table Concepts (
    id                      serial,
    name                    text not null,
    basic_info              text,
    info                    text,
    primary key (id)
);

create table Incorporates (
    concept_id              integer,
    molecule_id             integer,
    basic_info              text,
    info                    text,
    primary key (concept_id, molecule_id),
    foreign key (concept_id) references Concepts(id),
    foreign key (molecule_id) references Concepts(id)
);