-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_deposits_v;
DROP TABLE IF EXISTS pos_deposits;

-- Tabelle Positionen
CREATE TABLE IF NOT EXISTS pos_deposits (
    id         VARCHAR(11),
    doc_id     VARCHAR(8),
    ad_id      INTEGER,
    ad_dsg     VARCHAR(30),
    amt        NUMERIC(10,2),
    cmt        VARCHAR(50),
    CONSTRAINT pk_dps_pos PRIMARY KEY (id),
    CONSTRAINT fk_dps_doc FOREIGN KEY (doc_id)
    REFERENCES doc_deposits (id),
    CONSTRAINT fk_dps_acc FOREIGN KEY (ad_id)
    REFERENCES cat_accounts (id)
);