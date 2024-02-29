-- View
CREATE OR REPLACE VIEW doc_incomes_v
AS
SELECT di.id                 AS doc_id 
      ,di.dat                AS doc_dat
      ,di.amt                AS doc_amt
      ,di.rls                AS doc_rls
      ,pi.id                 AS pos_id
      ,ta.id                 AS ta_id
      ,ta.designation        AS ta_dsg
      ,pg.id                 AS pg_id
      ,pg.designation        AS pg_dsg
      ,pd.id                 AS pd_id
      ,pd.designation        AS pd_dsg   
      ,pi.amt                AS pos_amt
      ,pi.cmt                AS pos_cmt
  FROM      doc_incomes      AS di
  LEFT JOIN pos_incomes      AS pi ON pi.doc_id = di.id
  LEFT JOIN cat_posts        AS pd ON pd.id     = pi.pd_id
  LEFT JOIN cat_postgroups   AS pg ON pg.id     = pd.pg_id
  LEFT JOIN cat_transactions AS ta ON ta.id     = pg.ta_id
 ORDER BY di.id DESC, pi.id DESC;



 -- Access
SELECT di.id                 AS doc_id 
      ,di.dat                AS doc_dat
      ,di.amt                AS doc_amt
      ,di.rls                AS doc_rls
      ,pi.id                 AS pos_id
      ,ta.id                 AS ta_id
      ,ta.designation        AS ta_dsg
      ,pg.id                 AS pg_id
      ,pg.designation        AS pg_dsg
      ,pd.id                 AS pd_id
      ,pd.designation        AS pd_dsg   
      ,pi.amt                AS pos_amt
      ,pi.cmt                AS pos_cmt
  FROM   (((pos_incomes      AS pi
  LEFT JOIN cat_posts        AS pd ON pd.id = pi.pd_id)
  LEFT JOIN cat_postgroups   AS pg ON pg.id = pd.pg_id)
  LEFT JOIN cat_transactions AS ta ON ta.id = pg.ta_id)
 RIGHT JOIN doc_incomes      AS di ON di.id = pi.doc_id
 ORDER BY di.id DESC, pi.id DESC;