-- View
CREATE OR REPLACE VIEW doc_assets_v
AS
SELECT dass.id          AS doc_id 
      ,dass.dat         AS doc_dat
      ,dass.amt         AS doc_amt
      ,dass.rls         AS doc_rls
      ,pass.id          AS pos_id
      ,pass.dat         AS pos_dat
      ,pstv.ta_id       AS ta_id
      ,pstv.ta_dsg      AS ta_dsg
      ,pstv.pg_id       AS pg_id
      ,pstv.pg_dsg      AS pg_dsg
      ,pstv.pd_id       AS pd_id
      ,pstv.pd_dsg      AS pd_dsg   
      ,pass.amt         AS pos_amt
      ,pass.cmt         AS pos_cmt
  FROM      doc_assets  AS dass
  LEFT JOIN pos_assets  AS pass ON pass.doc_id = dass.id
  LEFT JOIN cat_posts_v AS pstv ON pstv.pd_id  = pass.pd_id
 ORDER BY dass.id DESC, pass.id DESC;

 -- Access
SELECT dass.id              AS doc_id 
      ,dass.dat             AS doc_dat
      ,dass.amt             AS doc_amt
      ,dass.rls             AS doc_rls
      ,pass.id              AS pos_id
      ,pass.dat             AS pos_dat
      ,ta.id              AS ta_id
      ,ta.designation     AS ta_dsg
      ,pg.id              AS pg_id
      ,pg.designation     AS pg_dsg
      ,pd.id              AS pd_id
      ,pd.designation     AS pd_dsg   
      ,pass.amt             AS pos_amt
      ,pass.cmt             AS pos_cmt
  FROM   (((pos_assets        pass
  LEFT JOIN cat_posts        pd ON pd.id     = pass.pd_id)
  LEFT JOIN cat_postgroups   pg ON pg.id     = pd.pg_id)
  LEFT JOIN cat_transactions ta ON ta.id     = pg.ta_id)
 RIGHT JOIN doc_assets        dass ON pass.doc_id = dass.id
 ORDER BY dass.id DESC, pass.id DESC;

 --
SELECT dass.id          AS doc_id 
      ,dass.dat         AS doc_dat
      ,dass.amt         AS doc_amt
      ,dass.rls         AS doc_rls
      ,pass.id          AS pos_id
      ,pass.dat         AS pos_dat
      ,pstv.ta_id       AS ta_id
      ,pstv.ta_dsg      AS ta_dsg
      ,pstv.pg_id       AS pg_id
      ,pstv.pg_dsg      AS pg_dsg
      ,pstv.pd_id       AS pd_id
      ,pstv.pd_dsg      AS pd_dsg   
      ,pass.amt         AS pos_amt
      ,pass.cmt         AS pos_cmt
  FROM     (pos_assets  AS pass
  LEFT JOIN cat_posts_v AS pstv ON pstv.pd_id = pass.pd_id)
 RIGHT JOIN doc_assets  AS dass ON dass.id    = pass.doc_id
 ORDER BY dass.id DESC, pass.id DESC;