-- Alle abhängige Objekte löschen
DROP VIEW  IF EXISTS posts_v;
DROP VIEW  IF EXISTS cat_posts_v;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS postgroups;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS cat_posts;
DROP TABLE IF EXISTS cat_postgroups;
DROP TABLE IF EXISTS cat_transactions;

-- Tabelle Transaktionen erstellen
CREATE TABLE IF NOT EXISTS cat_transactions(
    id          SERIAL,
    designation VARCHAR(30) NOT NULL,
    rank        CHAR(1),
    CONSTRAINT  pk_ta PRIMARY KEY (id)
);