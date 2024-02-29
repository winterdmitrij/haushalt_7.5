-- banks
-- Ekm / Agb ta_id <> get_taId_tra():
---- 1. Wie im Dok    (doc_id, pos_dat,      pos_id,            inf.def_acc,      pd_id,          pos_amt,       pos_cmt)
---- 2. Spez. Kontos  (doc_id, MAX(pos_dat), MAX(pos_id & 'a'), pta.ad_id,      get_pdId_trf(), SUM(pos_amt),  IIF(pos_amt < 0, 'Für ', 'Von ') & pd_dsg)
---- 3. Kompensierung (doc_id, MAX(pos_dat), MAX(pos_id & 'p'), get_adId_csh(), get_pdId_trf(), SUM(-pos_amt), 'Komp. von ' & pg_dsg)
-- Übw ta_dsg ta_id <> get_taId_tra():
---- 1. Aktiv  (doc_id, pos_dat,      pos_id & 'a',      inf.def_acc,      pd_id, pos_amt,       pos_cmt)
---- 2. Passiv (doc_id, MAX(pos_dat), MAX(pos_id & 'p'), get_adId_csh(), pd_id, SUM(-pos_amt), pd_dsg)
SELECT doc_id,
       dat,
       id,
       ad_id,
       pd_id,
       amt,
       cmt
FROM (
-- Ekm / Agb (ta_id <> get_taId_tra())
       -- Alle Einträge, wie im Dokument
       -- (doc_id, pos_dat,      pos_id,            inf.def_acc,      pd_id,          pos_amt,       pos_cmt)
       SELECT dbv.doc_id    AS doc_id,
              dbv.pos_dat   AS dat,
              dbv.pos_id    AS id,
              inf.def_acc   AS ad_id,
              dbv.pd_id     AS pd_id,
              dbv.pos_amt   AS amt,
              dbv.pos_cmt   AS cmt
        FROM  doc_banks_v   AS dbv
              inf_documents AS inf 
       WHERE dbv.doc_rls = FALSE
         AND inf.doc_type = "Spk"
         AND dbv.ta_id <> get_taId_tra()
       UNION
       -- Spez. Kontos
       SELECT doc_id,
              MAX(dat),
              MAX(id),
              ad_id,
              pd_id,
              SUM(amt),
              cmt
       FROM   (
              -- Aktiv
              -- (doc_id, MAX(pos_dat), MAX(pos_id & 'a'), pta.ad_id,      get_pdId_trf(), SUM(pos_amt),  IIF(pos_amt < 0, 'Für ', 'Von ') & pd_dsg)
              SELECT dbv.doc_id           AS doc_id,
                     dbv.pos_dat          AS dat,
                     dbv.pos_id & "a"     AS id,
                     pta.ad_id            AS ad_id,
                     get_pdId_trf()       AS pd_id,
                     dbv.pos_amt          AS amt,
                     IIF(dbv.pos_amt < 0,
                        'Für ',
                        'Von ') & dbv.pd_dsg    AS cmt
              FROM   (doc_banks_v               AS dbv
              LEFT   JOIN inf_posts_to_accounts AS pta
                ON   pta.pd_id = dbv.pd_id)
              WHERE  dbv.doc_rls = FALSE
                AND  dbv.ta_id <> get_taId_tra()
                AND  pta.ad_id IS NOT NULL
              UNION
              -- Passiv
              -- (doc_id, MAX(pos_dat), MAX(pos_id & 'p'), get_adId_csh(), get_pdId_trf(), SUM(-pos_amt), 'Komp. von ' & pg_dsg)
              SELECT dbv.doc_id                AS doc_id,
                     dbv.pos_dat               AS dat,
                     dbv.pos_id & "p"          AS id,
                     get_adId_csh()            AS ad_id,
                     get_pdId_trf()            AS pd_id,
                     -dbv.pos_amt              AS amt,
                     "Komp. von " & dbv.pg_dsg AS cmt
              FROM   doc_banks_v AS dbv
              LEFT   JOIN inf_posts_to_accounts AS pta
                ON   pta.pd_id = dbv.pd_id
              WHERE  dbv.doc_rls = FALSE
                AND  dbv.ta_id <> get_taId_tra()
                AND  pta.ad_id IS NOT NULL
       )
       GROUP BY doc_id, ad_id, pd_id, cmt
       UNION
-- Übw (ta_id <> get_taId_tra())       
       -- Aktiv
       -- (doc_id, pos_dat,      pos_id & 'a',      inf.def_acc,      pd_id, pos_amt,       pos_cmt)
       SELECT dbv.doc_id       AS doc_id,
              dbv.pos_dat      AS dat,
              dbv.pos_id & 'a' AS id,
              inf.def_acc      AS ad_id,
              dbv.pd_id        AS pd_id,
              dbv.pos_amt      AS amt,
              dbv.pos_cmt      AS cmt
        FROM  doc_banks_v      AS dbv,
              inf_documents    AS inf 
       WHERE dbv.doc_rls = FALSE
         AND inf.doc_type = "Spk"
         AND dbv.ta_id = get_taId_tra()
       UNION
       -- Passiv
       SELECT doc_id,
              MAX(dat),
              MAX(id),
              ad_id,
              pd_id,
              SUM(amt),
              cmt
       FROM   (
              -- (doc_id, MAX(pos_dat), MAX(pos_id & 'p'), get_adId_csh(), pd_id, SUM(-pos_amt), pd_dsg)
              SELECT dbv.doc_id       AS doc_id,
                     dbv.pos_dat      AS dat,
                     dbv.pos_id & "p" AS id,
                     get_adId_csh()   AS ad_id,
                     dbv.pd_id        AS pd_id,
                     -dbv.pos_amt     AS amt,
                     dbv.pd_dsg       AS cmt -- zB: Abbuchung, Einlegen oder Kartenzahlung
              FROM   doc_banks_v      AS dbv
              WHERE  dbv.doc_rls = FALSE
                AND  dbv.ta_id = get_taId_tra()
       )
       GROUP BY doc_id, ad_id, pd_id, cmt
)
WHERE doc_id = get_cur_docId()
ORDER BY id;


SELECT doc.doc_id, doc.dat, doc.id, doc.ad_id, acc.ad_dsg, doc.pd_id, doc.amt, doc.cmt
FROM (
  SELECT  dbv.doc_id      AS doc_id,
          dbv.pos_dat     AS dat,
          dbv.pos_id      AS id,
          inf.def_acc     AS ad_id,
          dbv.pd_id       AS pd_id,
          dbv.pos_amt     AS amt,
          dbv.pos_cmt     AS cmt
    FROM  doc_banks_v     AS dbv,
          inf_documents   AS inf
   WHERE  dbv.doc_rls = FALSE
     AND  inf.doc_type = "Spk"
     AND  dbv.ta_id <> get_taId_tra()
   UNION
  SELECT  doc_id
         ,MAX(dat)
         ,MAX(id)
         ,ad_id
         ,pd_id
         ,SUM(amt)
         ,cmt
    FROM (SELECT  dbv.doc_id              AS doc_id,
                  dbv.pos_dat             AS dat,
                  dbv.pos_id & "a"        AS id,
                  pta.ad_id               AS ad_id,
                  get_pdId_trf()          AS pd_id,
                  dbv.pos_amt             AS amt,
                  IIF(dbv.pos_amt < 0,
                      'Für ',
                      'Von ') & dbv.pd_dsg &
                      ": " & dbv.pos_cmt  AS cmt
            FROM (doc_banks_v             AS dbv
       LEFT JOIN  cat_posts_to_accounts   AS pta
              ON  pta.pd_id = dbv.pd_id)
           WHERE  dbv.doc_rls = FALSE
             AND  dbv.ta_id <> get_taId_tra()
             AND  pta.ad_id IS NOT NULL
           UNION
          SELECT  dbv.doc_id                AS doc_id,
                  dbv.pos_dat               AS dat,
                  dbv.pos_id & "p"          AS id,
                  get_adId_csh()            AS ad_id,
                  get_pdId_trf()            AS pd_id,
                 -dbv.pos_amt               AS amt,
                  "Komp. von " & dbv.pg_dsg AS cmt
            FROM (doc_banks_v               AS dbv
       LEFT JOIN  cat_posts_to_accounts     AS pta
              ON  pta.pd_id = dbv.pd_id)
           WHERE  dbv.doc_rls = FALSE
             AND  dbv.ta_id <> get_taId_tra()
             AND  pta.ad_id IS NOT NULL
         )
GROUP BY  doc_id, ad_id, pd_id, cmt
   UNION
  SELECT  dbv.doc_id       AS doc_id,
          dbv.pos_dat      AS dat,
          dbv.pos_id & 'a' AS id,
          inf.def_acc      AS ad_id,
          dbv.pd_id        AS pd_id,
          dbv.pos_amt      AS amt,
          dbv.pos_cmt      AS cmt
    FROM  doc_banks_v      AS dbv,
          inf_documents    AS inf 
   WHERE  dbv.doc_rls = FALSE
     AND  inf.doc_type = "Spk"
     AND  dbv.ta_id = get_taId_tra()
   UNION
  SELECT  doc_id
         ,MAX(dat)
         ,MAX(id)
         ,ad_id
         ,pd_id
         ,SUM(amt)
         ,cmt
    FROM (SELECT  dbv.doc_id         AS doc_id,
                  dbv.pos_dat        AS dat,
                  dbv.pos_id & "p"   AS id,
                  nz(pta.ad_id,
                     get_adId_csh()) AS ad_id,
                  dbv.pd_id          AS pd_id,
                 -dbv.pos_amt        AS amt,
                  dbv.pd_dsg         AS cmt
            FROM (doc_banks_v           AS dbv
       LEFT JOIN  cat_posts_to_accounts AS pta
              ON  pta.pd_id = dbv.pd_id)
           WHERE  dbv.doc_rls = FALSE
             AND  dbv.ta_id = get_taId_tra()
         )
GROUP BY  doc_id, ad_id, pd_id, cmt
)                         AS doc
LEFT JOIN  cat_accounts_v AS acc 
       ON  acc.ad_id = doc.ad_id
    WHERE LEFT(doc.doc_id, 4) = get_cur_prd()
 ORDER BY id;
