SELECT  prd,
        doc_id,
        dat,
        ta_dsg,
        pg_dsg,
        pd_dsg,
        ad_dsg,
        amt,
        cmt
FROM    (
        SELECT  grb.prd         AS prd,
                grb.doc_id      AS doc_id,
                CStr(grb.dat)   AS dat,
                grb.ta_dsg      AS ta_dsg,
                grb.pg_dsg      AS pg_dsg,
                grb.pd_dsg      AS pd_dsg,
                grb.ad_dsg      AS ad_dsg,
                grb.amt         AS amt,
                grb.cmt         AS cmt
        FROM    grb_operations_v grb
        UNION
        SELECT  grb.prd         AS prd,
                ''              AS doc_id,
                'Gesamt:'       AS dat,
                grb.ta_dsg      AS ta_dsg,
                ''              AS pg_dsg,
                ''              AS pd_dsg,
                grb.ad_dsg      AS ad_dsg,
                SUM(grb.amt)    AS amt,
                ''              AS cmt
        FROM    grb_operations_v grb
        GROUP BY prd, ta_dsg, ad_dsg
);