-- Alle Tabellen löschen
DROP VIEW  IF EXISTS cat_accounts_v;
DROP TABLE IF EXISTS cat_accounts;

-- Tabelle Konten
CREATE TABLE IF NOT EXISTS cat_accounts (
    id          SERIAL,
    designation VARCHAR(30) NOT NULL,
    description VARCHAR(50),
    rank        CHAR(1),
    ag_id       INT,
    save        BOOLEAN  DEFAULT FALSE,
    show        BOOLEAN  DEFAULT TRUE,
    active      BOOLEAN  DEFAULT TRUE,
    CONSTRAINT  pk_ad    PRIMARY KEY (id),
    CONSTRAINT  fk_ad_ag FOREIGN KEY (ag_id)
    REFERENCES  cat_accountgroups (id)
);

INSERT INTO cat_accounts (ag_id, rank, designation, description)
VALUES ( 1, 'a', 'Auto',                    'Autokosten'),
       ( 1, 'b', 'Einrichtung',             'Einrichtungsgegenstände'),
       ( 1, 'c', 'Geschenke',               'Feiertage: Geburtstage, Weihnachten, Ostern'),
       ( 1, 'd', 'Urlaub',                  'Für Urlaubs'),
       ( 2, 'a', 'Brieftasche',             'Für laufende Ausgaben'),
       ( 2, 'b', 'Reserven',                'Kurzfristige Einsparungen'),
       ( 3, 'a', 'Sparkasse',               'Sparkasse Dortmund'),
       ( 4, 'a', 'Anastasia',               '50€ pro Monat ab 1. Januar der 3. Klasse'),
       ( 4, 'b', 'Ekaterina',               '50€ pro Monat ab 1. Januar der 3. Klasse'),
       ( 4, 'c', 'Stefanie',                '50€ pro Monat ab 1. Januar der 3. Klasse'),
       ( 4, 'd', 'Tresor',                  'Langfristige Einsparungen für große Ziele'),
       ( 5, 'a', 'ImmoStart100 1500',       '1500 Euro monatlich'),
       ( 5, 'b', 'ImmoStart100 500',        '500 Euro monatlich'),
       ( 6, 'a', 'Basisrente Dmitrij',      '100 Euro monatlich'),
       ( 6, 'b', 'Basisrente Elisaveta',    '100 Euro monatlich'),
       ( 6, 'c', 'Mein Zukunft Anastasia',  '80 Euro monatlich'),
       ( 6, 'd', 'Mein Zukunft Ekaterina',  '60 Euro monatlich'),
       ( 6, 'e', 'Mein Zukunft Stefanie',   '50 Euro monatlich'),
       ( 7, 'b', 'DWS Global Growth',       '25 Euro monatlich'),
       ( 7, 'a', 'DWS US Growth',           '50 Euro monatlich'),
       ( 7, 'c', 'DWS VBF I LD',            '25 Euro monatlich');