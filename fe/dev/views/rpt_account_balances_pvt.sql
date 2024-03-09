TRANSFORM SUM(end) AS Summe
SELECT rank,
       ag_id,
       ag_dsg,
       ad_id,
       ad_dsg
FROM   rpt_account_balances_v
WHERE  get_year_by_prd(prd) = get_curYear()
GROUP  BY rank, ag_id, ag_dsg, ad_id, ad_dsg
ORDER  BY rank
PIVOT  get_monthName_by_prd(prd) In ('Jan','Feb','Mrz','Apr','Mai','Jun','Jul','Aug','Sep','Okt','Nov','Dez');
