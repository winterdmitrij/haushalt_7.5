-- rls_transfers_v
-- Deposits
-- Übw ta_dsg ta_id <> get_taId_tra():
---- 1. Aktiv  (doc_id, pos_dat,      pos_id & 'a',      ad_id,                 get_pdId_trf(), pos_amt,       pos_cmt)
---- 2. Passiv (doc_id, MAX(pos_dat), MAX(pos_id & 'p'), kad_id/get_adId_csh(), get_pdId_trf(), SUM(-pos_amt), pd_dsg)
SELECT  doc_id,
        dat,
        id,
        ad_id,
        pd_id,
        amt,
        cmt
FROM    (
        -- Aktiv
        -- (doc_id, pos_dat, pos_id & 'a', ad_id, get_pdId_trf(), pos_amt, pos_cmt)
        SELECT  ddv.doc_id        AS doc_id,
                ddv.doc_dat       AS dat,
                ddv.pos_id & "a"  AS id,
                ddv.ad_id         AS ad_id,
                get_pdId_trf()    AS pd_id,
                ddv.pos_amt       AS amt,
                ddv.pos_cmt       AS cmt
        FROM    doc_deposits_v    AS ddv
        WHERE   ddv.doc_rls = FALSE
        UNION
        -- Passiv
        SELECT  doc_id,
                dat,
                MAX(id),
                ad_id,
                pd_id,
                SUM(amt),
                cmt             --♥? IIF(SUM(amt) < 0, "Für ", "Von ") & cmt (um wenn Für Auto -200 und Von Urlaub 100 ergab Für AEGU -100)
        FROM    (
                -- (doc_id, MAX(pos_dat), MAX(pos_id & 'p'), kad_id/get_adId_csh(), get_pdId_trf(), SUM(-pos_amt), pd_dsg)
                SELECT  ddv.doc_id                    AS doc_id,
                        ddv.doc_dat                   AS dat,
                        ddv.pos_id & "p"              AS id,
                        Nz(ata.kad_id, inf.ad_id)     AS ad_id,
                        get_pdId_trf()                AS pd_id,
                        -ddv.pos_amt                  AS amt,
                        IIF(ddv.pos_amt > 0,
                            "Für ",
                            "Von ") & ddv.ag_dsg      AS cmt    --zB: Für AEGU / Von .... 
                FROM    doc_deposits_v                AS ddv,
                        doc_infos                     AS inf
                LEFT    JOIN inf_accounts_to_accounts AS ata    --♥! Neue Tabelle
                  ON    ata.dad_id = ddv.ad_id
                WHERE   dtv.doc_rls = FALSE
                  AND   inf.doc_type = "Dps"
        )
        GROUP   BY doc_id, dat, ad_id, pd_id, cmt
)
WHERE doc_id = get_cur_docId()
ORDER BY id;