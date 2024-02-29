-- Tabelle Konten_Posten
DROP VIEW  IF EXISTS cat_posts_to_accounts_v;
DROP TABLE IF EXISTS cat_posts_to_accounts;
DROP VIEW  IF EXISTS inf_posts_to_accounts_v;
DROP TABLE IF EXISTS inf_posts_to_accounts;

-- Tabelle erstellen
CREATE TABLE IF NOT EXISTS inf_posts_to_accounts (
    id         SERIAL,
    pd_id      INT,
    pd_dsg     VARCHAR(30),
    ad_id      INT,
    ad_dsg     VARCHAR(30),
    CONSTRAINT pk_pta    PRIMARY KEY (id),
    CONSTRAINT fk_pta_ad FOREIGN KEY (ad_id)
    REFERENCES cat_accounts (id),
    CONSTRAINT fk_pta_pd FOREIGN KEY (pd_id)
    REFERENCES cat_posts (id),
    CONSTRAINT uq_pta_pd UNIQUE (pd_id)
);


-- Tabelle befüllen
INSERT INTO inf_posts_to_accounts (ad_dsg, pd_dsg)
VALUES ('Auto',                     'Restausgaben'),
       ('Auto',                     'Reparatur-Service'),
       ('Auto',                     'Steuer'),
       ('Auto',                     'Straffe'),
       ('Auto',                     'Tanken'),
       ('Auto',                     'TÜV'),
       ('Auto',                     'Versicherung'),
       ('Brieftasche',              'Barauszahlung'),
       ('Brieftasche',              'Geldeinlegen'),
       ('Einrichtung',              'Haushaltgeräte'),
       ('Einrichtung',              'Komputertechnik'),
       ('Einrichtung',              'Möbel'),
       ('Einrichtung',              'Verkaufen'),
       ('Einrichtung',              'Vermögenswerte'),
       ('Geschenke',                'Feiertage'),
       ('Geschenke',                'Geburtstage'),
       ('Geschenke',                'Geldgeschenke'),
       ('Geschenke',                'Weihnachtsgeld'),
       ('ImmoStart100 1500',        'BauSparVertrag1500'),
       ('ImmoStart100 500',         'BauSparVertrag500'),
       ('ImmoStart100 500',         'Dima LV'),
       ('ImmoStart100 500',         'Lisa LV'),
       ('Basisrente Dmitrij',       'Vermögensaufbau Dima'),
       ('Basisrente Elisaveta',     'Vermögensaufbau Lisa'),
       ('Urlaub',                   'Tafel'),
       ('Urlaub',                   'Unterhalt'),
       ('Urlaub',                   'Unterkunft'),
       ('Urlaub',                   'Urlaubsgeld'),
       ('Mein Zukunft Anastasia',   'Mein Zukunft Anastasia'),
       ('Mein Zukunft Ekaterina',   'Mein Zukunft Ekaterina'),
       ('Mein Zukunft Stefanie',    'Mein Zukunft Stefanie');

UPDATE inf_posts_to_accounts pta
   SET ad_id = (SELECT ad.id
                  FROM cat_accounts ad
                 WHERE ad.designation = pta.ad_dsg),
       pd_id = (SELECT pd.id
                  FROM cat_posts pd
                 WHERE pd.designation = pta.pd_dsg);

-- Unnötige Spalten löschen
ALTER TABLE inf_posts_to_accounts
DROP COLUMN IF EXISTS ad_dsg,
DROP COLUMN IF EXISTS pd_dsg;


-- View erstellen
CREATE OR REPLACE VIEW inf_posts_to_accounts_v
AS
 SELECT pta.id                AS id
       ,pta.pd_id             AS pd_id
       ,pd.designation        AS pd_dsg
       ,pta.ad_id             AS ad_id
       ,ad.designation        AS ad_dsg
   FROM inf_posts_to_accounts AS pta
   JOIN cat_posts             AS pd ON pd.id = pta.pd_id
   JOIN cat_accounts          AS ad ON ad.id = pta.ad_id
  ORDER BY ad.designation;
