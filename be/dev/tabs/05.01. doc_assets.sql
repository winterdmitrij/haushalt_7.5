-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_assets_v;
DROP TABLE IF EXISTS pos_assets;
DROP TABLE IF EXISTS doc_assets CASCADE;

-- Tabelle Dokumenten
CREATE TABLE IF NOT EXISTS doc_assets (
    id         VARCHAR(8),
    dat        DATE,
    amt        NUMERIC(10,2) DEFAULT 0,
    rls        BOOLEAN  	 DEFAULT FALSE,
    CONSTRAINT pk_dass PRIMARY KEY (id)
);