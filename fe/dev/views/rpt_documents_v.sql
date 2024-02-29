SELECT  prd,
        rnk,
        id,
        dat,
        amt,
        rls,
        cnt
FROM    (
        SELECT  LEFT(dbv.doc_id,4) AS prd,
                1                  AS rnk,
                dbv.doc_id         AS id,
                dbv.doc_dat        AS dat,
                dbv.doc_amt        AS amt,
                IIF(dbv.doc_rls,
                    "ja", "nein")  AS rls,
                COUNT(dbv.pos_id)  AS cnt
        FROM    doc_banks_v        AS dbv
        GROUP   BY dbv.doc_id,
                   dbv.doc_dat,
                   dbv.doc_amt,
                   dbv.doc_rls
        UNION
        SELECT  LEFT(dev.doc_id,4) AS prd,
                2                  AS rnk,
                dev.doc_id         AS id,
                dev.doc_dat        AS dat,
                dev.doc_amt        AS amt,
                IIF(dev.doc_rls,
                    "ja", "nein")  AS rls,
                COUNT(dev.pos_id)  AS cnt
        FROM    doc_expenditures_v AS dev
        GROUP   BY dev.doc_id,
                   dev.doc_dat,
                   dev.doc_amt,
                   dev.doc_rls
        UNION
        SELECT  LEFT(div.doc_id,4) AS prd,
                3                  AS rnk,
                div.doc_id         AS id,
                div.doc_dat        AS dat,
                div.doc_amt        AS amt,
                IIF(div.doc_rls,
                    "ja", "nein")  AS rls,
                COUNT(div.pos_id)  AS cnt
        FROM    doc_incomes_v AS div
        GROUP   BY div.doc_id,
                   div.doc_dat,
                   div.doc_amt,
                   div.doc_rls
        UNION
        SELECT  LEFT(ddv.doc_id,4) AS prd,
                4                  AS rnk,
                ddv.doc_id         AS id,
                ddv.doc_dat        AS dat,
                ddv.doc_amt        AS amt,
                IIF(ddv.doc_rls,
                    "ja", "nein")  AS rls,
                COUNT(ddv.pos_id)  AS cnt
        FROM    doc_deposits_v AS ddv
        GROUP   BY ddv.doc_id,
                   ddv.doc_dat,
                   ddv.doc_amt,
                   ddv.doc_rls
        UNION
        SELECT  LEFT(asv.doc_id,4) AS prd,
                5                  AS rnk,
                asv.doc_id         AS id,
                asv.doc_dat        AS dat,
                asv.doc_amt        AS amt,
                IIF(asv.doc_rls,
                    "ja", "nein")  AS rls,
                COUNT(asv.pos_id)  AS cnt
        FROM    doc_assets_v       AS asv
        GROUP   BY asv.doc_id,
                   asv.doc_dat,
                   asv.doc_amt,
                   asv.doc_rls
)
WHERE   prd = get_curPrd()
ORDER   BY rnk;