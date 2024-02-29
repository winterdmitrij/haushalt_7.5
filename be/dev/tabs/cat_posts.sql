-- Alle Tabellen löschen
DROP VIEW  IF EXISTS posts_v;
DROP VIEW  IF EXISTS cat_posts_v;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS cat_posts;

-- Tabelle Posten
CREATE TABLE IF NOT EXISTS cat_posts (
    id          SERIAL,
    designation VARCHAR(30) NOT NULL,
    description VARCHAR(50),
    rank        CHAR(1),
    pg_id       INT,
    transfer    BOOL     DEFAULT FALSE,
    cash        BOOL     DEFAULT FALSE,
    active      BOOL     DEFAULT TRUE,
    CONSTRAINT  pk_pd    PRIMARY KEY (id),
    CONSTRAINT  fk_pd_pg FOREIGN KEY (pg_id)
    REFERENCES  cat_postgroups (id)
);