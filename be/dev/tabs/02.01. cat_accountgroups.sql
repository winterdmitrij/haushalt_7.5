-- Alle Tabellen löschen
DROP VIEW  IF EXISTS cat_accounts_v;
DROP TABLE IF EXISTS cat_accounts;
DROP TABLE IF EXISTS cat_accountgroups;

-- Tabelle Kontengruppen
CREATE TABLE IF NOT EXISTS cat_accountgroups (
    id          SERIAL,
    designation VARCHAR(30) NOT NULL,
    description VARCHAR(50),
    rank        CHAR(1),
    show        BOOlEAN DEFAULT TRUE,
    active      BOOlEAN DEFAULT TRUE,
    CONSTRAINT  pk_ag PRIMARY KEY (id)
);


INSERT INTO cat_accountgroups (designation, rank, description)
VALUES ('AEGU',             'a', 'Geld für: Auto, Einrichtung, Geschenke, Urlaub'),
       ('Bargeld',          'b', ''),
       ('Karten',           'c', 'Barloses Geld'),
       ('Einsparungen',     'd', 'Langfristige Einsparungen'),
       ('BauSparVertrag',   'e', 'Geld für zukunftigen Immobilien'),
       ('Vermögensaufbau',  'f', 'Geld für unseren Zukunft'),
       ('Investitionen',    'g', '');