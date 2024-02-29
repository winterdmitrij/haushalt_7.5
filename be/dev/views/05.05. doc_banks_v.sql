-- View
CREATE OR REPLACE VIEW doc_banks_v
AS
SELECT db.id                   AS doc_id 
      ,db.dat                  AS doc_dat
      ,db.amt                  AS doc_amt
      ,db.rls                  AS doc_rls
      ,pb.id                   AS pos_id
      ,pb.dat                  AS pos_dat
      ,ta.id                   AS ta_id
      ,ta.designation          AS ta_dsg
      ,pg.id                   AS pg_id
      ,pg.designation          AS pg_dsg
      ,pd.id                   AS pd_id
      ,pd.designation          AS pd_dsg   
      ,pb.amt                  AS pos_amt
      ,pb.cmt                  AS pos_cmt
  FROM      doc_banks        AS db
  LEFT JOIN pos_banks        AS pb ON pb.doc_id = db.id
  LEFT JOIN cat_posts        AS pd ON pd.id     = pb.pd_id
  LEFT JOIN cat_postgroups   AS pg ON pg.id     = pd.pg_id
  LEFT JOIN cat_transactions AS ta ON ta.id     = pg.ta_id
 ORDER BY db.id DESC, pb.id DESC;



 -- Access
SELECT db.id              AS doc_id 
      ,db.dat             AS doc_dat
      ,db.amt             AS doc_amt
      ,db.rls             AS doc_rls
      ,pb.id              AS pos_id
      ,pb.dat             AS pos_dat
      ,ta.id              AS ta_id
      ,ta.designation     AS ta_dsg
      ,pg.id              AS pg_id
      ,pg.designation     AS pg_dsg
      ,pd.id              AS pd_id
      ,pd.designation     AS pd_dsg   
      ,pb.amt             AS pos_amt
      ,pb.cmt             AS pos_cmt
  FROM   (((pos_banks        pb
  LEFT JOIN cat_posts        pd ON pd.id     = pb.pd_id)
  LEFT JOIN cat_postgroups   pg ON pg.id     = pd.pg_id)
  LEFT JOIN cat_transactions ta ON ta.id     = pg.ta_id)
 RIGHT JOIN doc_banks        db ON pb.doc_id = db.id
 ORDER BY db.id DESC, pb.id DESC;