INSERT INTO inf_documents
       (doc_type, doc_name, doc_tabl, doc_view, doc_form, pos_tabl, pos_form, rls_view, def_acc, doc_frq)
VALUES 
       ('Exp', 'Ausgaben', 'doc_expenditures', 'doc_expenditures_v', 'doc_expenditure', 'pos_expenditures', 'pos_posts', 'rls_expenditures_v', 5, 1),
       ('Inc', 'Einkommen', 'doc_incomes', 'doc_incomes_v', 'doc_income', 'pos_incomes', 'pos_posts', 'rls_incomes_v', 5, 1),
       ('Dps', 'Einlagen', 'doc_deposits', 'doc_deposits_v', 'doc_deposit', 'pos_deposits', 'pos_accounts', 'rls_deposits_v', 5, 1),
       ('Spk', 'Sparkasse', 'doc_banks', 'doc_banks_v', 'doc_bank', 'pos_banks', 'pos_posts', 'rls_banks_v', 7, 1),
       (150, 'Bausparvertrag-1500', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 12, 12),
       (050, 'Bausparvertrag-500', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 13, 12),
       (025, 'Bausparvertrag-250', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 23, 12),
       ('Brd', 'Basisrente Dmitrij', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 14, 12),
       ('Brl', 'Basisrente Elisaveta', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 15, 12),
       ('Mza', 'MeinZukunft Anastasia', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 16, 12),
       ('Mze', 'MeinZukunft Ekaterina', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 17, 12),
       ('Mzs', 'MeinZukunft Stefanie', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 18, 12),