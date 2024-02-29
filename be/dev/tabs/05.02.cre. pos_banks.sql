-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_banks_v;
DROP TABLE IF EXISTS pos_banks;

-- Tabelle Positionen
CREATE TABLE IF NOT EXISTS pos_banks (
    id         VARCHAR(11),
    dat        DATE,
    pd_id      INTEGER,
    pd_dsg     VARCHAR(30),
    amt        NUMERIC(10,2),
    cmt        VARCHAR(50),
    doc_id     VARCHAR(8),
    CONSTRAINT pk_pb     PRIMARY KEY (id),
    CONSTRAINT fk_pb_db  FOREIGN KEY (doc_id)
    REFERENCES doc_banks (id),
    CONSTRAINT fk_pb_pd  FOREIGN KEY (pd_id)
    REFERENCES cat_posts (id)
);