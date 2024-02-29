-- View
CREATE OR REPLACE VIEW doc_expenditures_v
AS
SELECT de.id                   AS doc_id 
      ,de.dat                  AS doc_dat
      ,de.amt                  AS doc_amt
      ,de.rls                  AS doc_rls
      ,pe.id                   AS pos_id
      ,ta.id                   AS ta_id
      ,ta.designation          AS ta_dsg
      ,pg.id                   AS pg_id
      ,pg.designation          AS pg_dsg
      ,pd.id                   AS pd_id
      ,pd.designation          AS pd_dsg   
      ,pe.amt                  AS pos_amt
      ,pe.cmt                  AS pos_cmt
  FROM      doc_expenditures AS de
  LEFT JOIN pos_expenditures AS pe ON pe.doc_id = de.id
  LEFT JOIN cat_posts        AS pd ON pd.id     = pe.pd_id
  LEFT JOIN cat_postgroups   AS pg ON pg.id     = pd.pg_id
  LEFT JOIN cat_transactions AS ta ON ta.id     = pg.ta_id
 ORDER BY de.id DESC, pe.id DESC;



 -- Access
SELECT de.id                   AS doc_id 
      ,de.dat                  AS doc_dat
      ,de.amt                  AS doc_amt
      ,de.rls                  AS doc_rls
      ,pe.id                   AS pos_id
      ,ta.id                   AS ta_id
      ,ta.designation          AS ta_dsg
      ,pg.id                   AS pg_id
      ,pg.designation          AS pg_dsg
      ,pd.id                   AS pd_id
      ,pd.designation          AS pd_dsg
      ,pe.amt_dtl              AS pos_amtDtl  
      ,pe.amt                  AS pos_amt
      ,pe.cmt                  AS pos_cmt
  FROM   (((pos_expenditures   AS pe
  LEFT JOIN cat_posts          AS pd ON pd.id = pe.pd_id)
  LEFT JOIN cat_postgroups     AS pg ON pg.id = pd.pg_id)
  LEFT JOIN cat_transactions   AS ta ON ta.id = pg.ta_id)
 RIGHT JOIN doc_expenditures   AS de ON de.id = pe.doc_id
 ORDER BY de.id DESC, pe.id DESC;