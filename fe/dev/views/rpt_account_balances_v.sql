SELECT rank,
       prd,
       ag_id,
       ag_dsg,
       ad_id,
       ad_dsg,
       beg,
       inc,
       exp,
       trf,
       sld,
       [end]
FROM  (SELECT "0"                                        AS rank, 
              bal.prd                                    AS prd, 
              0                                          AS ag_id, 
              ""                                         AS ag_dsg, 
              0                                          AS ad_id, 
              "Insgesamt:"                               AS ad_dsg, 
              SUM(bal.beg)                               AS beg, 
              SUM(bal.inc)                               AS inc, 
              SUM(bal.exp)                               AS exp, 
              SUM(bal.tra)                               AS trf, 
              SUM(bal.inc + bal.exp + bal.tra)           AS sld, 
              SUM(bal.beg + bal.inc + bal.exp + bal.tra) AS [end]
       FROM  (rpt_balance         AS bal 
       INNER  JOIN cat_accounts_v AS cav ON cav.ad_id = bal.ad_id)
       GROUP  BY bal.prd
       UNION  ALL
       SELECT LEFT(cav.rank, 1)                          AS rank, 
              bal.prd                                    AS prd, 
              cav.ag_id                                  AS ag_id, 
              cav.ag_dsg                                 AS ag_dsg, 
              cav.ag_id * 100                            AS ad_id, 
              "Gesamt " & cav.ag_dsg & ":"               AS ad_dsg, 
              SUM(bal.beg)                               AS beg, 
              SUM(bal.inc)                               AS inc, 
              SUM(bal.exp)                               AS exp, 
              SUM(bal.tra)                               AS trf, 
              SUM(bal.inc + bal.exp + bal.tra)           AS sld, 
              SUM(bal.beg + bal.inc + bal.exp + bal.tra) AS [end]
       FROM  (rpt_balance         AS bal 
       INNER  JOIN cat_accounts_v AS cav ON cav.ad_id = bal.ad_id)
       GROUP  BY LEFT(cav.rank, 1), 
                 bal.prd, 
                 cav.ag_id, 
                 cav.ag_dsg
       UNION  ALL
       SELECT cav.rank                               AS rank, 
              bal.prd                                AS prd, 
              cav.ag_id                              AS ag_id, 
              cav.ag_dsg                             AS ag_dsg, 
              cav.ad_id                              AS ad_id, 
              "-" & cav.ad_dsg                       AS ad_dsg, 
              bal.beg                                AS beg, 
              bal.inc                                AS inc, 
              bal.exp                                AS exp, 
              bal.tra                                AS trf, 
             (bal.inc + bal.exp + bal.tra)           AS sld, 
             (bal.beg + bal.inc + bal.exp + bal.tra) AS [end]
       FROM  (rpt_balance         AS bal 
       INNER  JOIN cat_accounts_v AS cav ON cav.ad_id = bal.ad_id)
      )
ORDER BY prd, rank;