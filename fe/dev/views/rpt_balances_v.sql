-- Neue Version
-- SEHR LANGSAM
SELECT   rank,
         ag_id,
         ag_dsg,
         ad_id,
         ad_dsg,
         beg_std,
         inc,
         exp,
         trf,
         bal,
         end_std
FROM    (SELECT   acc.rank                     AS rank,
                  grb.prd                      AS prd,
                  grb.ag_id                    AS ag_id,
                  grb.ag_dsg                   AS ag_dsg, 
                  grb.ad_id                    AS ad_id, 
                  grb.ad_dsg                   AS ad_dsg, 
                 (SELECT   NZ(SUM(grb1.amt), 0)
                  FROM     grb_operations_v  grb1
                  WHERE    grb1.ad_id = grb.ad_id
                  AND      grb1.prd < grb.prd) AS beg_std,
                 (SELECT   NZ(SUM(grb2.amt), 0)
                  FROM     grb_operations_v  grb2
                  WHERE    grb2.ad_id = grb.ad_id          
                  AND      grb2.prd = grb.prd            
                  AND      grb2.ag_dsg = "Einkommen") AS inc, 


                  null AS exp,
                  null AS trf,
                  null AS bal,
                  null AS end_std
      FROM (grb_operations_v           grb
      LEFT JOIN cat_accounts_v         acc
      ON acc.ad_id = grb.ad_id))            AS balance
ORDER BY prd, rank;