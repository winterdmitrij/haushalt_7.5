TRANSFORM SUM(end) AS Summe
SELECT  rnk,
        ag_id,
        ag_dsg,
        ad_id,
        ad_dsg
FROM   (SELECT  rbv.prd           AS prd,
                LEFT(rbv.rank, 1) AS rnk,
                rbv.ag_id         AS ag_id,
                rbv.ag_dsg        AS ag_dsg,
                0                 AS ad_id,
                "Gesamt " & 
                rbv.ag_dsg & ":"  AS ad_dsg,
                rbv.end           AS end
        FROM    rpt_balance_v     AS rbv
        UNION ALL
        SELECT  rbv.prd           AS prd,
                rbv.rank          AS rnk,
                rbv.ag_id         AS ag_id,
                rbv.ag_dsg        AS ag_dsg,
                rbv.ad_id         AS ad_id,
                "- " & rbv.ad_dsg AS ad_dsg,
                rbv.end           AS end
        FROM    rpt_balance_v     AS rbv
       )  AS [%$##@_Alias]
WHERE   LEFT(CStr(prd),2)=LEFT(get_curPrd(),2)
GROUP   BY rnk, ag_id, ag_dsg, ad_id, ad_dsg
PIVOT MonthName(RIGHT(CStr(prd),2),True) In ('Jan','Feb','Mrz','Apr','Mai','Jun','Jul','Aug','Sep','Okt','Nov','Dez');
