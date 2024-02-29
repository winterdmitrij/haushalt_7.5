-- Tabelle löschen
DROP TABLE IF EXISTS cat_periods;

-- Tabelle erstellen
CREATE TABLE IF NOT EXISTS cat_periods (
    period     INT,
    CONSTRAINT pk_prd PRIMARY KEY (period)
);

-- Tabelle befüllen
INSERT INTO cat_periods (period)
VALUES (2201),
       (2202),
       (2203),
       (2204),
       (2205),
       (2206),
       (2207),
       (2208),
       (2209),
       (2210),
       (2211),
       (2212),
       (2301),
       (2302),
       (2303),
       (2304),
       (2305),
       (2306),
       (2307),
       (2308);