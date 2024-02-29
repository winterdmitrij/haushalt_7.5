INSERT INTO inf_catalogs
       (itm_name, itm_abrv, itm_tabl, prt_item, cld_item)
VALUES 
       ('Transaktion', 'ta', 'cat_transactions', '', 'Postgruppe'),
       ('Postgruppe', 'pg', 'cat_postgroups', 'ta_id', 'Post'),
       ('Post', 'pd', 'cat_posts', 'pg_id', ''),
       ('Kontengruppe', 'ag', 'cat_accountgroups', '', 'Konto'),
       ('Konto', 'ad', 'cat_accouns', 'ag_id', ''),