-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_expenditures_v;
DROP TABLE IF EXISTS pos_expenditures;
DROP TABLE IF EXISTS doc_expenditures;

-- Tabelle Dokumenten
CREATE TABLE IF NOT EXISTS doc_expenditures (
    id          VARCHAR(8),
    dat         DATE,
    amt         NUMERIC(10,2) DEFAULT 0,
    rls         BOOLEAN DEFAULT FALSE,
    CONSTRAINT  pk_exp_doc PRIMARY KEY (id)
);

-- Tabelle at_kaz_dokumente befüllen
INSERT INTO doc_expenditures (id, dat)
VALUES ('2201-Exp', '31.01.2022'),
       ('2202-Exp', '28.02.2022'),
       ('2203-Exp', '31.03.2022'),
       ('2204-Exp', '30.04.2022'),
       ('2205-Exp', '31.05.2022'),
       ('2206-Exp', '30.06.2022'),
       ('2207-Exp', '31.07.2022'),
       ('2208-Exp', '31.08.2022'),
       ('2209-Exp', '30.09.2022'),
       ('2210-Exp', '31.10.2022'),
       ('2211-Exp', '30.11.2022'),
       ('2212-Exp', '31.12.2022'),
       ('2301-Exp', '31.01.2023'),
       ('2302-Exp', '28.02.2023'),
       ('2303-Exp', '31.03.2023'),
       ('2304-Exp', '30.04.2023'),
       ('2305-Exp', '31.05.2023'),
       ('2306-Exp', '30.06.2023'),
       ('2307-Exp', '31.07.2023'),
       ('2308-Exp', '31.08.2023');