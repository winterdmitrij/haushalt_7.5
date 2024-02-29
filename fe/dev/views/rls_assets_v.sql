SELECT doc.doc_id,
       doc.dat,
       doc.id,
       doc.ad_id,
       doc.pd_id,
       doc.amt,
       doc.cmt
FROM   (
        SELECT dav.doc_id      AS doc_id,
               dav.pos_dat     AS dat,
               dav.pos_id      AS id,
               inf.def_acc     AS ad_id,
               dav.pd_id       AS pd_id,
               dav.pos_amt     AS amt,
               dav.pos_cmt     AS cmt
        FROM   doc_assets_v       dav
        LEFT   JOIN inf_documents inf
        ON     inf.doc_type = mid(dav.doc_id, 6, 3)
       ) AS doc
WHERE  LEFT(doc.doc_id, 4) = get_curPrd()
  AND  doc.doc_id = get_curDocId()
ORDER  BY id;