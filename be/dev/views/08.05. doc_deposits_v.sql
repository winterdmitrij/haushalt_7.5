-- View
CREATE OR REPLACE VIEW doc_deposits_v
AS
SELECT dd.id                  AS doc_id 
      ,dd.dat                 AS doc_dat
      ,dd.amt                 AS doc_amt
      ,dd.rls                 AS doc_rls
      ,pd.id                  AS pos_id
      ,ag.id                  AS ag_id
      ,ag.designation         AS ag_dsg
      ,ad.id                  AS ad_id
      ,ad.designation         AS ad_dsg   
      ,pd.amt                 AS pos_amt
      ,pd.cmt                 AS pos_cmt
  FROM      doc_deposits      AS dd
  LEFT JOIN pos_deposits      AS pd ON dd.id = pd.doc_id
  LEFT JOIN cat_accounts      AS ad ON ad.id = pd.ad_id
  LEFT JOIN cat_accountgroups AS ag ON ag.id = ad.ag_id
 ORDER BY dd.id DESC, pd.id DESC;



 -- Access
SELECT dd.id                  AS doc_id 
      ,dd.dat                 AS doc_dat
      ,dd.amt                 AS doc_amt
      ,dd.rls                 AS doc_rls
      ,pd.id                  AS pos_id
      ,ag.id                  AS ag_id
      ,ag.designation         AS ag_dsg
      ,ad.id                  AS ad_id
      ,ad.designation         AS ad_dsg   
      ,pd.amt                 AS pos_amt
      ,pd.cmt                 AS pos_cmt
  FROM    ((pos_deposits  AS pd
  LEFT JOIN cat_accounts      AS ad ON ad.id = pd.ad_id)
  LEFT JOIN cat_accountgroups AS ag ON ag.id = ad.ag_id)
 RIGHT JOIN doc_deposits  AS dd ON dd.id = pd.doc_id
 ORDER BY dd.id DESC, pd.id DESC;