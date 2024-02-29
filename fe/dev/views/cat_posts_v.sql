-- Access
SELECT ta.rank + pg.rank + pd.rank AS rank,
       ta.id                       AS ta_id,
       ta.designation              AS ta_dsg,
       pg.id                       AS pg_id,
       pg.designation              AS pg_dsg,
       pg.active                   AS pg_act,
       pd.id                       AS pd_id,
       pd.designation              AS pd_dsg,
       pd.active                   AS pd_act,
       pd.transfer                 AS pd_trf,
       pd.cash                     AS pd_csh
 FROM (cat_transactions   AS ta 
 LEFT JOIN cat_postgroups AS pg ON pg.ta_id = ta.id) 
 LEFT JOIN cat_posts      AS pd ON pd.pg_id = pg.id
WHERE pg.active = TRUE
  AND pd.active = TRUE 
ORDER BY ta.rank + pg.rank + pd.rank;