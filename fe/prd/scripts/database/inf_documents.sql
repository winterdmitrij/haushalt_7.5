INSERT INTO inf_documents
       (doc_type, doc_name, doc_tabl, doc_view, doc_form, pos_tabl, pos_form, rls_view, def_acc)
VALUES 
       ('Exp', 'Ausgaben', 'doc_expenditures', 'doc_expenditures_v', 'doc_expenditure', 'pos_expenditures', 'pos_posts', 'rls_expenditures_v', 5),
       ('Inc', 'Einkommen', 'doc_incomes', 'doc_incomes_v', 'doc_income', 'pos_incomes', 'pos_posts', 'rls_incomes_v', 5),
       ('Dps', 'Einlagen', 'doc_deposits', 'doc_deposits_v', 'doc_deposit', 'pos_deposits', 'pos_accounts', 'rls_deposits_v', 5),
       ('Spk', 'Sparkasse', 'doc_banks', 'doc_banks_v', 'doc_bank', 'pos_banks', 'pos_posts', 'rls_banks_v', 7),
       (150, 'Bausparvertrag-1500', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 12),
       (050, 'Bausparvertrag-500', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 13),
       (025, 'Bausparvertrag-250', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 23),
       ('Brd', 'Basisrente Dmitrij', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 14),
       ('Brl', 'Basisrente Elisaveta', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 15),
       ('Mza', 'MeinZukunft Anastasia', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 16),
       ('Mze', 'MeinZukunft Ekaterina', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 17),
       ('Mzs', 'MeinZukunft Stefanie', 'doc_assets', 'doc_assets_v', 'doc_asset', 'pos_assets', 'pos_posts', 'rls_assets_v', 18),