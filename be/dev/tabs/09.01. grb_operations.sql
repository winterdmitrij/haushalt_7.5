-- Tabelle löschen
DROP VIEW  IF EXISTS grb_operations_v;
DROP TABLE IF EXISTS grb_operations;

-- Tabelle erstellen
CREATE TABLE IF NOT EXISTS grb_operations (
    id         VARCHAR(12),
    dat        DATE,
    ad_id      INTEGER,
    ad_dsg     VARCHAR(30),
    pd_id      INTEGER,
    pd_dsg     VARCHAR(30),
    amt        NUMERIC(10,2),
    cmt        VARCHAR(50),
    CONSTRAINT pk_grb PRIMARY KEY (id)
)

-- Tabelle mit Anfangsstände befüllen
INSERT INTO grb_operations 
       (id,             dat,        ad_dsg,        pd_dsg,         amt,      cmt)
VALUES ('2112-SoA.01a', '31.12.2021', 'Auto',        'Anfangsstand', 1221.93,  'Anfangsstand'),
       ('2112-SoA.02a', '31.12.2021', 'Einrichtung', 'Anfangsstand', 41.36,    'Anfangsstand'),
       ('2112-SoA.03a', '31.12.2021', 'Geschenke',   'Anfangsstand', 5.63,     'Anfangsstand'),
       ('2112-SoA.04a', '31.12.2021', 'Urlaub',      'Anfangsstand', 196,      'Anfangsstand'),
       ('2112-SoA.05a', '31.12.2021', 'Reserven',    'Anfangsstand', 2000,     'Anfangsstand'),
       ('2112-SoA.06a', '31.12.2021', 'Brieftasche', 'Anfangsstand', 576,      'Anfangsstand'),
       ('2112-SoA.07a', '31.12.2021', 'Sparkasse',   'Anfangsstand', 1594.98,  'Anfangsstand'),
       ('2112-SoA.08a', '31.12.2021', 'Tresor',      'Anfangsstand', 40000,    'Anfangsstand'),
       ('2112-SoA.09a', '31.12.2021', 'Anastasia',   'Anfangsstand', 1800,     'Anfangsstand'),
       ('2112-SoA.10a', '31.12.2021', 'Ekaterina',   'Anfangsstand', 600,      'Anfangsstand'),
       ('2112-SoA.11a', '31.12.2021', 'Stefanie',    'Anfangsstand', 0,        'Anfangsstand');

-- Tabelle update (ad_id und pd_id befüllen)
UPDATE grb_operations AS grb
   SET ad_id = (SELECT ad.id
                  FROM cat_accounts AS ad
                  WHERE ad.designation = grb.ad_dsg),
       pd_id = (SELECT pd.id
                  FROM cat_posts AS pd
                 WHERE pd.designation = grb.pd_dsg);

-- Tabelle alter (ad_dsg, pd_dsg dropen)
ALTER TABLE grb_operations
DROP COLUMN pd_dsg;

ALTER TABLE grb_operations
DROP COLUMN ad_dsg;


-- View erstellen
-- ToDo: vllt. doc_id hinzufügen
CREATE OR REPLACE VIEW grb_operations_v
AS
SELECT gb.id            AS id, 
       gb.dat           AS dat, 
       ta.id            AS ta_id, 
       ta.designation   AS ta_dsg, 
       pg.id            AS pg_id, 
       pg.designation   AS pg_dsg, 
       pd.id            AS pd_id, 
       pd.designation   AS pd_dsg, 
       ag.id            AS ag_id, 
       ag.designation   AS ag_dsg, 
       ad.id            AS ad_id, 
       ad.designation   AS ad_dsg, 
       gb.amt           AS amt, 
       gb.cmt           AS cmt, 
       to_number(to_char(gb.dat,'YYMM'), '9999') AS prd, 
       SUBSTRING(gb.id,6,3)   AS typ,
       LEFT(gb.id, 8)   AS doc_id
FROM grb_operations AS gb 
LEFT JOIN cat_posts AS pd ON gb.pd_id = pd.id
LEFT JOIN cat_postgroups AS pg ON pd.pg_id = pg.id
LEFT JOIN cat_transactions AS ta ON pg.ta_id = ta.id
LEFT JOIN cat_accounts AS ad ON gb.ad_id = ad.id
LEFT JOIN cat_accountgroups AS ag ON ad.ag_id = ag.id
ORDER BY gb.id DESC;



-- Access
SELECT gb.id            AS id, 
       gb.dat           AS dat, 
       ta.id            AS ta_id, 
       ta.designation   AS ta_dsg, 
       pg.id            AS pg_id, 
       pg.designation   AS pg_dsg, 
       pd.id            AS pd_id, 
       pd.designation   AS pd_dsg, 
       ag.id            AS ag_id, 
       ag.designation   AS ag_dsg, 
       ad.id            AS ad_id, 
       ad.designation   AS ad_dsg, 
       gb.amt           AS amt, 
       gb.cmt           AS cmt, 
       Format(gb.dat,'yymm') AS prd,
       Mid(gb.id,6,3)   AS typ,
       Left(gb.id, 8)   AS doc_id
FROM ((((grb_operations AS gb 
LEFT JOIN cat_posts AS pd ON gb.pd_id = pd.id) 
LEFT JOIN cat_postgroups AS pg ON pd.pg_id = pg.id) 
LEFT JOIN cat_transactions AS ta ON pg.ta_id = ta.id) 
LEFT JOIN cat_accounts AS ad ON gb.ad_id = ad.id) 
LEFT JOIN cat_accountgroups AS ag ON ad.ag_id = ag.id
ORDER BY gb.id DESC;