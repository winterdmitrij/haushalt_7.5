SELECT doc_id,
       dat,
       id,
       ad_id,
       pd_id,
       amt,
       cmt
FROM   (
       SELECT dev.doc_id     AS doc_id, 
              dev.doc_dat    AS dat, 
              dev.pos_id     AS id, 
              inf.def_acc    AS ad_id,
              dev.pd_id      AS pd_id,
              dev.pos_amt    AS amt, 
              dev.pos_cmt    AS cmt
       FROM   doc_expenditures_v AS dev,
              inf_documents      AS inf
       WHERE  dev.doc_rls  = FALSE
         AND  inf.doc_type = "Exp"
       UNION
       SELECT doc_id,
              dat,
              MAX(id),
              ad_id,
              pd_id,
              SUM(amt),
              cmt
       FROM   (  
              SELECT dev.doc_id          AS doc_id,
                     dev.doc_dat         AS dat,
                     dev.pos_id & "a"    AS id,
                     pta.ad_id           AS ad_id,
                     get_pdId_trf()      AS pd_id,
                     dev.pos_amt         AS amt,
                     "Für " & dev.pd_dsg & 
                     ": " & dev.pos_cmt  AS cmt
              FROM   (doc_expenditures_v        AS dev
              LEFT   JOIN cat_posts_to_accounts AS pta 
                ON   pta.pd_id = dev.pd_id)
              WHERE  dev.doc_rls  = FALSE
                AND  pta.ad_id IS NOT NULL
                AND  pta.ad_id <> get_adId_csh()
              UNION
              SELECT dev.doc_id                AS doc_id,
                     dev.doc_dat               AS dat,
                     dev.pos_id & "p"          AS id,
                     get_adId_csh()            AS ad_id,
                     get_pdId_trf()            AS pd_id,
                     -dev.pos_amt              AS amt,
                     "Komp. von " & dev.pg_dsg AS cmt
              FROM  (doc_expenditures_v         AS dev
              LEFT   JOIN cat_posts_to_accounts AS pta 
                ON   pta.pd_id = dev.pd_id)
              WHERE  dev.doc_rls  = FALSE
                AND  pta.ad_id IS NOT NULL
                AND  pta.ad_id <> get_adId_csh()
      )
      GROUP BY doc_id, dat, ad_id, pd_id, cmt
)
WHERE LEFT(doc_id, 4) = get_curPrd()
ORDER BY id;