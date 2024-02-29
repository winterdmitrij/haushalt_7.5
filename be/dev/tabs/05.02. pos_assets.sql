-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_assets_v;
DROP TABLE IF EXISTS pos_assets;

-- Tabelle Positionen
CREATE TABLE IF NOT EXISTS pos_assets (
    id         VARCHAR(11),
    dat        DATE,
    pd_id      INTEGER,
    amt        NUMERIC(10,2),
    cmt        VARCHAR(50),
    doc_id     VARCHAR(8),
    CONSTRAINT pk_pass      PRIMARY KEY (id),
    CONSTRAINT fk_pass_dass FOREIGN KEY (doc_id)
    REFERENCES doc_assets (id),
    CONSTRAINT fk_pass_pstd FOREIGN KEY (pd_id)
    REFERENCES cat_posts (id)
);