-- Tabelle leeren
DELETE FROM pos_incomes;

-- Tabelle befüllen
INSERT INTO cat_transactions
       (id, designation,     rank)
VALUES (1,  'Ausgaben',      'a'),
       (2,  'Einkommen',     'e'),
       (3,  'Überweisungen', 'u');