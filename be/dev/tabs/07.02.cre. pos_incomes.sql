-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_incomes_v;
DROP TABLE IF EXISTS pos_incomes;

-- Tabelle Positionen
CREATE TABLE IF NOT EXISTS pos_incomes (
    id         VARCHAR(11),
    pd_id      INTEGER,
    pd_dsg     VARCHAR(30),
    amt        NUMERIC(10,2),
    cmt        VARCHAR(50),
    doc_id     VARCHAR(8),
    CONSTRAINT pk_inc_pos PRIMARY KEY (id),
    CONSTRAINT fk_inc_doc FOREIGN KEY (doc_id)
    REFERENCES doc_incomes (id),
    CONSTRAINT fk_inc_pst FOREIGN KEY (pd_id)
    REFERENCES cat_posts (id)
);