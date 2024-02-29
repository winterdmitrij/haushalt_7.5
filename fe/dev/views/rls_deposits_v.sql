SELECT  doc_id,
        dat,
        id,
        ad_id,
        pd_id,
        amt,
        cmt
FROM    (
        SELECT  ddv.doc_id         AS doc_id,
                ddv.doc_dat        AS dat,
                ddv.pos_id & "a"   AS id,
                ddv.ad_id          AS ad_id,
                get_pdId_dep()     AS pd_id,
                ddv.pos_amt        AS amt,
                "Monatseinlage " & ddv.pos_cmt        AS cmt
        FROM    doc_deposits_v     AS ddv
        WHERE   ddv.doc_rls = FALSE
        UNION
        SELECT  doc_id,
                dat,
                MAX(id),
                ad_id,
                pd_id,
                SUM(amt),
                cmt
        FROM    (
                SELECT  ddv.doc_id               AS doc_id,
                        ddv.doc_dat              AS dat,
                        ddv.pos_id & "p"         AS id,
                        Nz(ata.kad_id,
                           get_adId_csh())       AS ad_id,
                        get_pdId_dep()           AS pd_id,
                        -ddv.pos_amt             AS amt,
                        IIF(ddv.pos_amt > 0,
                            "Für ",
                            "Von ") & ddv.ag_dsg AS cmt 
                FROM   (doc_deposits_v                AS ddv
                LEFT    JOIN inf_accounts_to_accounts AS ata
                  ON    ata.dad_id = ddv.ad_id)
                WHERE   ddv.doc_rls = FALSE
        )
        GROUP BY doc_id, dat, ad_id, pd_id, cmt
)
WHERE LEFT(doc_id, 4) = get_curPrd()
  AND amt <> 0
ORDER BY id;