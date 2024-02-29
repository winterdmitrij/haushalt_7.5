-- Alle Tabellen löschen
DROP VIEW  IF EXISTS posts_v;
DROP VIEW  IF EXISTS cat_posts_v;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS postgroups;
DROP TABLE IF EXISTS cat_posts;
DROP TABLE IF EXISTS cat_postgroups;


-- Tabelle Postgruppen
CREATE TABLE IF NOT EXISTS cat_postgroups (
    id          SERIAL,
    designation VARCHAR(30) NOT NULL,
    description VARCHAR(50),
    ta_id       INT,
    rank        CHAR(1),
    active      BOOL DEFAULT TRUE,
    CONSTRAINT  pk_pg PRIMARY KEY (id),
    CONSTRAINT  fk_pg_ta FOREIGN KEY (ta_id)
    REFERENCES  cat_transactions (id) ON DELETE SET NULL
);

INSERT INTO cat_postgroups (designation, rank, ta_id, description)
VALUES ('Mobilität',         'a', 1, ''),
       ('Kinder',            'b', 1, ''),
       ('Auto',              'c', 1, ''),
       ('Lebensmittel',      'd', 1, ''),
       ('HPG',               'e', 1, 'Haushalt, Pflege, Gesundheit'),
       ('Garderobe',         'f', 1, ''),
       ('Einrichtung',       'g', 1, ''),
       ('Freizeit',          'h', 1, ''),
       ('Urlaub',            'i', 1, ''),
       ('Natur',             'j', 1, ''),
       ('Geschenke',         'k', 1, ''),
       ('Wohnung',           'l', 1, ''),
       ('Sonstige Ausgaben', 'm', 1, ''),
       ('Lohn und Gehalt',   'a', 2, ''),
       ('Familienkasse',     'b', 2, ''),
       ('Sonstige Einkommen','c', 2, ''),
       ('Jobcenter',         'd', 2, ''),
       ('Kontostand',        'a', 3, 'Anfangsstand und Korrigierung'),
       ('Geldverkehr',       'b', 3, '');