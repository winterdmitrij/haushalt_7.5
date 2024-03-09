TRANSFORM Sum(Nz(sld,0)) AS Betragsumme
SELECT rank, pd_id, pd_dsg, Sum(Nz(sld,0)) AS Gesamt
FROM rpt_post_balances_v
WHERE get_year_by_prd(prd) = get_curYear()
GROUP BY rank, pd_id, pd_dsg
ORDER BY rank
PIVOT get_monthName_by_prd(prd) In ('Jan','Feb','Mrz','Apr','Mai','Jun','Jul','Aug','Sep','Okt','Nov','Dez');
