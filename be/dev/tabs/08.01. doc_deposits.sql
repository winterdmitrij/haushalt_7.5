-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_deposits_v;
DROP TABLE IF EXISTS pos_deposits;
DROP TABLE IF EXISTS doc_deposits;

-- Tabelle Dokumenten
CREATE TABLE IF NOT EXISTS doc_deposits (
    id          VARCHAR(8),
    dat         DATE,
    amt         NUMERIC(10,2) DEFAULT 0,
    rls         BOOLEAN DEFAULT FALSE,
    CONSTRAINT  pk_dps_doc PRIMARY KEY (id)
);

-- Tabelle at_kaz_dokumente befüllen
INSERT INTO doc_deposits (id, dat)
VALUES ('2201-Dps', '31.01.2022'),
       ('2202-Dps', '28.02.2022'),
       ('2203-Dps', '31.03.2022'),
       ('2204-Dps', '30.04.2022'),
       ('2205-Dps', '31.05.2022'),
       ('2206-Dps', '30.06.2022'),
       ('2207-Dps', '31.07.2022'),
       ('2208-Dps', '31.08.2022'),
       ('2209-Dps', '30.09.2022'),
       ('2210-Dps', '31.10.2022'),
       ('2211-Dps', '30.11.2022'),
       ('2212-Dps', '31.12.2022'),
       ('2301-Dps', '31.01.2023'),
       ('2302-Dps', '28.02.2023'),
       ('2303-Dps', '31.03.2023'),
       ('2304-Dps', '30.04.2023'),
       ('2305-Dps', '31.05.2023'),
       ('2306-Dps', '30.06.2023'),
       ('2307-Dps', '31.07.2023'),
       ('2308-Dps', '31.08.2023');