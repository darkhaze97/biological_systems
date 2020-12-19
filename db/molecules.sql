-- Written by Tim Huang 


-- Create the molecule tables first, THEN create the relationship tables between them to ensure
-- that all the tables are correctly loaded into the database.

create table Sequences (
    sequence                text,
    residue_no              integer,
    primary key (sequence)
);

create table Proteins (
    id                      serial,
    name                    text,
    denatured_by            text,
    origin                  text,
    bond_types              text,
    secondary_structure     text,
    tertiary_structure      text,
    quaternary_structure    text,
    sequence                text not null,
    primary key (id),
    foreign key (sequence) references Sequences(sequence)
);



create table Binds_to (
    protein_id              serial,
    nucleic_acid_id         serial,
    effect                  text,
    motif                   text,
    primary key (protein_id, nucleic_acid_id),
    foreign key (protein_id) references Proteins(id),
    foreign key (nucleic_acid_id) references Nucleic_Acids(id)
);