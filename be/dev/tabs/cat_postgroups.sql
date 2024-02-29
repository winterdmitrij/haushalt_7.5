-- Alle Tabellen löschen
DROP VIEW  IF EXISTS posts_v;
DROP VIEW  IF EXISTS cat_posts_v;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS postgroups;
DROP TABLE IF EXISTS cat_posts;
DROP TABLE IF EXISTS cat_postgroups;


-- Tabelle Postgruppen
CREATE TABLE IF NOT EXISTS cat_postgroups (
    id          SERIAL,
    designation VARCHAR(30) NOT NULL,
    description VARCHAR(50),
    ta_id       INT,
    rank        CHAR(1),
    active      BOOL DEFAULT TRUE,
    CONSTRAINT  pk_pg    PRIMARY KEY (id),
    CONSTRAINT  fk_pg_ta FOREIGN KEY (ta_id)
    REFERENCES  cat_transactions (id) ON DELETE SET NULL
);