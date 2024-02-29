-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_incomes_v;
DROP TABLE IF EXISTS pos_incomes;
DROP TABLE IF EXISTS doc_incomes;

-- Tabelle Dokumenten
CREATE TABLE IF NOT EXISTS doc_incomes (
    id          VARCHAR(8),
    dat         DATE,
    amt         NUMERIC(10,2) DEFAULT 0,
    rls         BOOLEAN DEFAULT FALSE,
    CONSTRAINT  pk_inc_doc PRIMARY KEY (id)
);

-- Tabelle at_kaz_dokumente befüllen
INSERT INTO doc_incomes (id, dat)
VALUES ('2201-Inc', '31.01.2022'),
       ('2202-Inc', '28.02.2022'),
       ('2203-Inc', '31.03.2022'),
       ('2204-Inc', '30.04.2022'),
       ('2205-Inc', '31.05.2022'),
       ('2206-Inc', '30.06.2022'),
       ('2207-Inc', '31.07.2022'),
       ('2208-Inc', '31.08.2022'),
       ('2209-Inc', '30.09.2022'),
       ('2210-Inc', '31.10.2022'),
       ('2211-Inc', '30.11.2022'),
       ('2212-Inc', '31.12.2022'),
       ('2301-Inc', '31.01.2023'),
       ('2302-Inc', '28.02.2023'),
       ('2303-Inc', '31.03.2023'),
       ('2304-Inc', '30.04.2023'),
       ('2305-Inc', '31.05.2023'),
       ('2306-Inc', '30.06.2023'),
       ('2307-Inc', '31.07.2023'),
       ('2308-Inc', '31.08.2023');