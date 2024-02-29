-- Balanz-Ansicht. benutzt zum jahres Pivot-Ansicht
SELECT cav.rank                               AS rank, 
       bal.prd                                AS prd, 
       cav.ag_id                              AS ag_id, 
       cav.ag_dsg                             AS ag_dsg, 
       cav.ad_id                              AS ad_id, 
       cav.ad_dsg                             AS ad_dsg, 
       bal.beg                                AS beg, 
       bal.inc                                AS inc, 
       bal.exp                                AS exp, 
       bal.tra                                AS tra, 
      (bal.inc + bal.exp + bal.tra)           AS sld, 
      (bal.beg + bal.inc + bal.exp + bal.tra) AS [end]
FROM  (rpt_balance         AS bal 
INNER  JOIN cat_accounts_v AS cav ON cav.ad_id = bal.ad_id);