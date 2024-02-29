-- Tabelle löschen
DROP TABLE IF EXISTS cat_infos;
DROP TABLE IF EXISTS inf_catalogs;

-- Tabelle Katalogs-Inormation
CREATE TABLE IF NOT EXISTS inf_catalogs (
    itm_name    VARCHAR(30),                -- Bezeichnung des Katalogs
    itm_abrv    VARCHAR(2),                 -- 2-Stellige Kürzung der engl. Bezeichnung
    itm_tabl    VARCHAR(30) NOT NULL,       -- Tabellenname des Katalogs
    prt_item    VARCHAR(5),                 -- Eltern- (parent) Katalog
    cld_item    VARCHAR(30),                -- Kind- (child) Katalog
    CONSTRAINT pk_ic PRIMARY KEY (itm_name)
);

-- item, table, parent, child_item
INSERT INTO inf_catalogs (itm_name, itm_abrv, itm_tabl, prt_item, cld_item)
VALUES ('Transaktion',  'ta',   'cat_transactions',   NULL,       'Postgruppe'),
       ('Postgruppe',   'pg',   'cat_postgroups',     'ta_id',    'Post'),
       ('Post',         'pd',   'cat_posts',          'pg_id',    NULL),
       ('Kontengruppe', 'ag',   'cat_accountgroups',  NULL,       'Konto'),
       ('Konto',        'ad',   'cat_accouns',        'ag_id',    NULL);