SELECT  doc_id,
        dat,
        id,
        ad_id,
        pd_id,
        amt,
        cmt
FROM (
      SELECT div.doc_id     AS doc_id,
             div.doc_dat    AS dat,
             div.pos_id     AS id,
             inf.def_acc      AS ad_id,
             div.pd_id      AS pd_id,
             div.pos_amt    AS amt,
             div.pos_cmt    AS cmt
        FROM doc_incomes_v  AS div,
             inf_documents  AS inf
       WHERE div.doc_rls = FALSE
         AND inf.doc_type = "Inc"
      UNION
      SELECT doc_id
            ,dat
            ,MAX(id)
            ,ad_id
            ,pd_id
            ,SUM(amt)
            ,cmt
      FROM (  
            SELECT div.doc_id          AS doc_id,
                   div.doc_dat         AS dat,
                   div.pos_id & "a"    AS id,
                   pta.ad_id           AS ad_id,
                   get_pdId_trf()      AS pd_id,
                   div.pos_amt         AS amt,
                   "Von " & div.pd_dsg &
                   ": " & div.pos_cmt  AS cmt
            FROM  (doc_incomes_v              AS div
            LEFT   JOIN cat_posts_to_accounts AS pta 
              ON   pta.pd_id = div.pd_id)
            WHERE  div.doc_rls  = FALSE
              AND  pta.ad_id IS NOT NULL
              AND  pta.ad_id <> get_adId_csh()
            UNION
            SELECT div.doc_id                AS doc_id,
                   div.doc_dat               AS dat,
                   div.pos_id & "p"          AS id,
                   get_adId_csh()            AS ad_id,
                   get_pdId_trf()            AS pd_id,
                  -div.pos_amt               AS amt,
                   "Komp. von " & div.pg_dsg AS cmt
            FROM  (doc_incomes_v              AS div
            LEFT   JOIN cat_posts_to_accounts AS pta 
              ON   pta.pd_id = div.pd_id)
            WHERE  div.doc_rls  = FALSE
              AND  pta.ad_id IS NOT NULL
              AND  pta.ad_id <> get_adId_csh()
      )
      GROUP BY doc_id, dat, ad_id, pd_id, cmt
)
WHERE LEFT(doc_id, 4) = get_cur_prd()
ORDER BY id;
