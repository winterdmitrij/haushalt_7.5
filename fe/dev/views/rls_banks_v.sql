SELECT  doc.doc_id,
        doc.dat,
        doc.id,
        doc.ad_id,
        doc.pd_id,
        doc.amt,
        doc.cmt
FROM    (
        SELECT  dbv.doc_id      AS doc_id,
                dbv.pos_dat     AS dat,
                dbv.pos_id      AS id,
                inf.ad_id       AS ad_id,
                dbv.pd_id       AS pd_id,
                dbv.pos_amt     AS amt,
                dbv.pos_cmt     AS cmt
        FROM    doc_banks_v     AS dbv,
                inf_documents   AS inf 
        WHERE   inf.doc_type = "Spk"
          AND   dbv.ta_id <> get_taId_tra()
        UNION
        SELECT  doc_id
               ,MAX(dat)
               ,MAX(id)
               ,ad_id
               ,pd_id
               ,SUM(amt)
               ,cmt
        FROM    (
                SELECT  dbv.doc_id              AS doc_id,
                        dbv.pos_dat             AS dat,
                        dbv.pos_id & "a"        AS id,
                        pta.ad_id               AS ad_id,
                        get_pdId_trf()          AS pd_id,
                        dbv.pos_amt             AS amt,
                        IIF(dbv.pos_amt < 0,
                           'Für ',
                           'Von ') & dbv.pd_dsg &
                           ": " & dbv.pos_cmt   AS cmt
                FROM   (doc_banks_v                AS dbv
                LEFT    JOIN cat_posts_to_accounts AS pta
                  ON    pta.pd_id = dbv.pd_id)
                WHERE   dbv.ta_id <> get_taId_tra()
                  AND   pta.ad_id IS NOT NULL
                UNION
                SELECT  dbv.doc_id                AS doc_id,
                        dbv.pos_dat               AS dat,
                        dbv.pos_id & "p"          AS id,
                        get_adId_csh()            AS ad_id,
                        get_pdId_trf()            AS pd_id,
                        -dbv.pos_amt              AS amt,
                        "Komp. von " & dbv.pg_dsg AS cmt
                FROM   (doc_banks_v                AS dbv
                LEFT    JOIN cat_posts_to_accounts AS pta
                  ON    pta.pd_id = dbv.pd_id)
                WHERE   dbv.ta_id <> get_taId_tra()
                AND     pta.ad_id IS NOT NULL
        )
        GROUP BY  doc_id, ad_id, pd_id, cmt
        UNION
        SELECT  dbv.doc_id       AS doc_id,
                dbv.pos_dat      AS dat,
                dbv.pos_id & 'a' AS id,
                inf.ad_id        AS ad_id,
                dbv.pd_id        AS pd_id,
                dbv.pos_amt      AS amt,
                dbv.pos_cmt      AS cmt
        FROM    doc_banks_v      AS dbv,
                inf_documents    AS inf 
        WHERE   inf.doc_type = "Spk"
          AND   dbv.ta_id = get_taId_tra()
        UNION
        SELECT  doc_id
               ,MAX(dat)
               ,MAX(id)
               ,ad_id
               ,pd_id
               ,SUM(amt)
               ,cmt
        FROM    ( 
                SELECT  dbv.doc_id         AS doc_id,
                        dbv.pos_dat        AS dat,
                        dbv.pos_id & "p"   AS id,
                        nz(pta.ad_id,
                           get_adId_csh()) AS ad_id,
                        dbv.pd_id          AS pd_id,
                        -dbv.pos_amt       AS amt,
                        dbv.pd_dsg         AS cmt
                FROM   (doc_banks_v                AS dbv
                LEFT    JOIN cat_posts_to_accounts AS pta
                  ON    pta.pd_id = dbv.pd_id)
                WHERE   dbv.ta_id = get_taId_tra()
        )
        GROUP BY  doc_id, ad_id, pd_id, cmt
) AS doc
WHERE LEFT(doc.doc_id, 4) = get_curPrd()
ORDER BY id;