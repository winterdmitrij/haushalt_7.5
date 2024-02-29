-- Tabelle leeren
DELETE FROM inf_documents;

-- Tabelle befüllen
INSERT INTO inf_documents 
       (doc_name,                   doc_type,   doc_tabl,           pos_tabl,           doc_view,               rls_view,               doc_form,           pos_form,      def_acc, doc_frq)
VALUES ('Ausgaben',                 'Exp',     'doc_expenditures', 'pos_expenditures', 'doc_expenditures_v',   'rls_expenditures_v',   'doc_expenditure',  'pos_posts',    5,       1),
       ('Einkommen',                'Inc',     'doc_incomes',      'pos_incomes',      'doc_incomes_v',        'rls_incomes_v',        'doc_income',       'pos_posts',    5,       1),
       ('Einlagen',                 'Dps',     'doc_deposits',     'pos_deposits',     'doc_deposits_v',       'rls_deposits_v',       'doc_deposit',      'pos_accounts', 5,       1),
       ('Sparkasse',                'Spk',     'doc_banks',        'pos_banks',        'doc_banks_v',          'rls_banks_v',          'doc_bank',         'pos_posts',    7,       1),
       ('Bausparvertrag-1500',      '150',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    12,      12),
       ('Bausparvertrag-500',       '050',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    13,      12),
       ('Bausparvertrag-250',       '025',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    23,      12),
       ('Basisrente Dmitrij',       'Brd',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    14,      12),
       ('Basisrente Elisaveta',     'Brl',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    15,      12),
       ('MeinZukunft Anastasia',    'Mza',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    16,      12),
       ('MeinZukunft Ekaterina',    'Mze',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    17,      12),
       ('MeinZukunft Stefanie',     'Mzs',     'doc_assets',       'pos_assets',       'doc_assets_v',         'rls_assets_v',         'doc_asset',        'pos_posts',    18,      12);