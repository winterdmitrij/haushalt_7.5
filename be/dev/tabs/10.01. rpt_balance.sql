-- Tabelle löschen
-- http://cornelia-boenigk.de/sites/default/files/dokumente/pg-datentypen.pdf
DROP TABLE IF EXISTS rpt_balance;

-- Erstellen
CREATE TABLE IF NOT EXISTS rpt_balance (
    prd     INTEGER,
    ad_id   INTEGER,
    beg     NUMERIC(10, 2),
    inc     NUMERIC(10, 2),
    exp     NUMERIC(10, 2),
    tra     NUMERIC(10, 2),
    CONSTRAINT pk_bal    PRIMARY KEY (prd, ad_id),
    CONSTRAINT fk_bal_ad FOREIGN KEY (ad_id)
    REFERENCES cat_accounts (id)
);


-- View erstellen
DROP VIEW IF EXISTS rpt_balance_v;

-- View erstellen
CREATE OR REPLACE VIEW rpt_balance_v
AS
SELECT  bal.prd           AS prd,
        ag.id             AS ag_id,
        ad.designation    AS ag_dsg,
        ad.id             AS ad_id,
        ad.designation    AS ad_dsg,
        bal.beg           AS beg,
        bal.inc           AS inc,
        bal.exp           AS exp,
        bal.tra           AS tra,
       (bal.inc + bal.exp + bal.tra)            AS sld,
       (bal.beg + bal.inc + bal.exp + bal.tra)  AS end
   FROM rpt_balance             AS bal
   INNER JOIN cat_accounts      AS ad ON ad.id = bal.ad_id
   INNER JOIN cat_accountgroups AS ag ON ag.id = ad.ag_id;


-- Access
SELECT  ag.rank & ad.rank AS rank,
        bal.prd           AS prd,
        ag.id             AS ag_id,
        ag.designation    AS ag_dsg,
        ad.id             AS ad_id,
        ad.designation    AS ad_dsg,
        bal.beg           AS beg,
        bal.inc           AS inc,
        bal.exp           AS exp,
        bal.tra           AS tra,
       (bal.inc + bal.exp + bal.tra)            AS sld,
       (bal.beg + bal.inc + bal.exp + bal.tra)  AS end
   FROM ((rpt_balance             AS bal
   INNER JOIN cat_accounts      AS ad ON ad.id = bal.ad_id)
   INNER JOIN cat_accountgroups AS ag ON ag.id = ad.ag_id)
   WHERE bal.prd = get_cur_prd();



-- Worum weiter geht, habe  ich KA.
-- Insert
INSERT INTO rpt_balance
        (prd, ad_id, beg, inc, exp, tra)
SELECT 	2201 AS prd,
       	ad.id AS ad_id,
		(SELECT coalesce(SUM(grb.amt), 0)
		 FROM	grb_operations_v grb
		WHERE	grb.prd < 2201
		AND		grb.ad_id = ad.id) AS beg,
		(SELECT coalesce(SUM(grb.amt), 0)
		 FROM	grb_operations_v grb
		WHERE	grb.prd = 2201
		AND		grb.ad_id = ad.id
		AND		grb.ta_dsg = 'Einkommen') AS Inc,
		(SELECT coalesce(SUM(grb.amt), 0)
		 FROM	grb_operations_v grb
		WHERE	grb.prd = 2201
		AND		grb.ad_id = ad.id
		AND		grb.ta_dsg = 'Ausgaben') AS Exp,
		(SELECT coalesce(SUM(grb.amt), 0)
		 FROM	grb_operations_v grb
		WHERE	grb.prd = 2201
		AND		grb.ad_id = ad.id
		AND		grb.ta_dsg = 'Überweisungen') AS Tra
FROM    cat_accounts AS ad;


INSERT INTO rpt_balance
      (prd, ad_id, beg, inc, exp, tra)
SELECT  get_cur_prd()    AS prd,
        ad.id   AS ad_id, 
        (SELECT Nz(SUM(amt), 0)
         FROM grb_operations
         WHERE Format(dat, 'yymm') < get_cur_prd()
         AND ad_id = ad.id) AS beg,
        (SELECT NZ(SUM(sub.amt), 0)
          FROM (((grb_operations     AS sub
          LEFT JOIN cat_posts        AS pd ON pd.id = sub.pd_id)
          LEFT JOIN cat_postgroups   AS pg ON pg.id = pd.pg_id)
          LEFT JOIN cat_transactions AS ta ON ta.id = pg.ta_id)
          WHERE sub.ad_id = ad.id
          AND Format(sub.dat,'yymm') = get_cur_prd()
          AND ta.designation = "Einkommen") AS inc,
        (SELECT NZ(SUM(sub.amt), 0)
          FROM (((grb_operations     AS sub
          LEFT JOIN cat_posts        AS pd ON pd.id = sub.pd_id)
          LEFT JOIN cat_postgroups   AS pg ON pg.id = pd.pg_id)
          LEFT JOIN cat_transactions AS ta ON ta.id = pg.ta_id)
          WHERE sub.ad_id = ad.id
          AND Format(sub.dat,'yymm') = get_cur_prd()
          AND ta.designation = "Ausgaben") AS exp,
        (SELECT NZ(SUM(sub.amt), 0)
          FROM (((grb_operations     AS sub
          LEFT JOIN cat_posts        AS pd ON pd.id = sub.pd_id)
          LEFT JOIN cat_postgroups   AS pg ON pg.id = pd.pg_id)
          LEFT JOIN cat_transactions AS ta ON ta.id = pg.ta_id)
          WHERE sub.ad_id = ad.id
          AND Format(sub.dat,'yymm') = get_cur_prd()
          AND ta.designation = "Überweisungen") AS tra
FROM    cat_accounts AS ad;