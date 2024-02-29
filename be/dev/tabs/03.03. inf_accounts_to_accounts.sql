-- Tabelle Konten_Konten
DROP VIEW  IF EXISTS inf_accounts_to_accounts_v;
DROP TABLE IF EXISTS inf_accounts_to_accounts;

-- Tabelle erstellen
CREATE TABLE IF NOT EXISTS inf_accounts_to_accounts (
    id         SERIAL,
    dad_id     INT,
    dad_dsg    VARCHAR(30),
    kad_id     INT,
    kad_dsg    VARCHAR(30),
    CONSTRAINT pk_ata    PRIMARY KEY (id),
    CONSTRAINT fk_ata_dad FOREIGN KEY (dad_id)
    REFERENCES cat_accounts (id),
    CONSTRAINT fk_ata_kad FOREIGN KEY (kad_id)
    REFERENCES cat_accounts (id),
    CONSTRAINT uq_ata_dad UNIQUE (dad_id)
);


-- Tabelle befüllen
INSERT INTO inf_accounts_to_accounts (dad_dsg, kad_dsg)
VALUES ('Tresor', 'Reserven');

UPDATE inf_accounts_to_accounts ata
   SET kad_id = (SELECT ad.id
                  FROM cat_accounts ad
                 WHERE ad.designation = ata.kad_dsg),
       dad_id = (SELECT ad.id
                  FROM cat_accounts ad
                 WHERE ad.designation = ata.dad_dsg);

-- Unnötige Spalten löschen
ALTER TABLE inf_accounts_to_accounts
DROP COLUMN IF EXISTS kad_dsg,
DROP COLUMN IF EXISTS dad_dsg;