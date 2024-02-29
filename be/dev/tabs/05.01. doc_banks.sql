-- Alle Tabellen löschen
DROP VIEW  IF EXISTS doc_banks_v;
DROP TABLE IF EXISTS pos_banks;
DROP TABLE IF EXISTS doc_banks CASCADE;

-- Tabelle Dokumenten
CREATE TABLE IF NOT EXISTS doc_banks (
    id         VARCHAR(8),
    dat        DATE,
    amt        NUMERIC(10,2) DEFAULT 0,
    rls        BOOLEAN  	 DEFAULT FALSE,
    CONSTRAINT pk_db PRIMARY KEY (id)
);

-- Tabelle at_kaz_dokumente befüllen
INSERT INTO doc_banks (id, dat)
VALUES ('2201-Spk', '31.01.2022'),
       ('2202-Spk', '28.02.2022'),
       ('2203-Spk', '31.03.2022'),
       ('2204-Spk', '30.04.2022'),
       ('2205-Spk', '31.05.2022'),
       ('2206-Spk', '30.06.2022'),
       ('2207-Spk', '31.07.2022'),
       ('2208-Spk', '31.08.2022'),
       ('2209-Spk', '30.09.2022'),
       ('2210-Spk', '31.10.2022'),
       ('2211-Spk', '30.11.2022'),
       ('2212-Spk', '31.12.2022'),
       ('2301-Spk', '31.01.2023'),
       ('2302-Spk', '28.02.2023'),
       ('2303-Spk', '31.03.2023'),
       ('2304-Spk', '30.04.2023'),
       ('2305-Spk', '31.05.2023'),
       ('2306-Spk', '30.06.2023'),
       ('2307-Spk', '31.07.2023'),
       ('2308-Spk', '31.08.2023');