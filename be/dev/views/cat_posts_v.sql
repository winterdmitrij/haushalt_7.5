-- View Posten
CREATE OR REPLACE VIEW cat_posts_v
AS
  SELECT ta.rank || pg.rank || pd.rank AS rank,
         ta.id                         AS ta_id,
         ta.designation                AS ta_dsg,
         pg.id                         AS pg_id,
         pg.designation                AS pg_dsg,
         pd.id                         AS pd_id,
         pd.designation                AS pd_dsg,
         pd.transfer                   AS transfer,
         pd.cash                       AS cash,
         pd.active                     AS active
    FROM cat_posts             pd
   RIGHT JOIN cat_postgroups   pg ON pg.id = pd.pg_id
   RIGHT JOIN cat_transactions ta ON ta.id = pg.ta_id
   ORDER BY ta.rank || pg.rank || pd.rank;
