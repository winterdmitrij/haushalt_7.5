-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_expenditures_v;
DROP TABLE IF EXISTS pos_expenditures;

-- Tabelle Positionen
CREATE TABLE IF NOT EXISTS pos_expenditures (
    id         VARCHAR(11),
    pd_id      INTEGER,
    pd_dsg     VARCHAR(30),
    amt_dtl    VARCHAR(500),
    amt        NUMERIC(10,2),
    cmt        VARCHAR(50),
    doc_id     VARCHAR(8),
    CONSTRAINT pk_exp_pos PRIMARY KEY (id),
    CONSTRAINT fk_exp_doc FOREIGN KEY (doc_id)
    REFERENCES doc_expenditures (id),
    CONSTRAINT fk_exp_pst FOREIGN KEY (pd_id)
    REFERENCES cat_posts (id)
);
