-- Tabelle leeren
DELETE FROM pos_incomes;

-- Tabelle füllen
-- ToDo: Nicht vergessen, -Ek durch -Inc ersetzen
INSERT INTO pos_incomes (doc_id, id, amt, pd_dsg, cmt)
VALUES  ('2201-Inc', '2201-Inc.01',  20, 'Verkaufen', 'Altes Fahrrad'),
        ('2202-Inc', '2202-Inc.01',  50, 'Geldgeschenke', ''),
        ('2203-Inc', '2203-Inc.01',  50, 'Geldgeschenke', ''),
        ('2203-Inc', '2203-Inc.02',  100, 'Artem', 'Internet: 01-05. 2022'),
        ('2204-Inc', '2204-Inc.01',  120, 'Erstattungen', 'Eltern für Sprit'),
        ('2207-Inc', '2207-Inc.01',  100, 'Geldgeschenke', ''),
        ('2210-Inc', '2210-Inc.01',  100, 'Geldgeschenke', 'Eltern'),
        ('2210-Inc', '2210-Inc.02',  140, 'Artem', 'Für Internet 06-12.22'),
        ('2210-Inc', '2210-Inc.03',  1150, 'Geldgeschenke', 'Elvira Petrovna'),
        ('2302-Inc', '2302-Inc.01',  300, 'Verkaufen', 'Kitchenate'),
        ('2303-Inc', '2303-Inc.01',  100, 'Verkaufen', 'Backofen'),
        ('2304-Inc', '2304-Inc.01',  40, 'Dima LV', ''),
        ('2304-Inc', '2304-Inc.02',  40, 'Lisa LV', ''),
        ('2305-Inc', '2305-Inc.01',  40, 'Dima LV', ''),
        ('2305-Inc', '2305-Inc.02',  40, 'Lisa LV', ''),
        ('2305-Inc', '2305-Inc.03',  75, 'Verkaufen', 'Fahrrad'),
        ('2305-Inc', '2305-Inc.04',  20, 'Verkaufen', 'Anhänger'),
        ('2306-Inc', '2306-Inc.01',  40, 'Lisa LV', ''),
        ('2306-Inc', '2306-Inc.02',  40, 'Dima LV', ''),
        ('2307-Inc', '2307-Inc.01',  30, 'Verkaufen', 'Altes Sofa'),
        ('2307-Inc', '2307-Inc.02',  80, 'Geldgeschenke', 'Opa für Katjas Rollschuhe'),
        ('2307-Inc', '2307-Inc.03',  40, 'Dima LV', ''),
        ('2307-Inc', '2307-Inc.04',  40, 'Lisa LV', ''),
        ('2308-Inc', '2308-Inc.01',  40, 'Dima LV', '');