-- View Konten
CREATE OR REPLACE VIEW cat_accounts_v
AS
 SELECT ag.rank || ad.rank AS rank,
        ag.id              AS ag_id,
        ag.designation     AS ag_dsg,
        ad.id              AS ad_id,
        ad.designation     AS ad_dsg,
        ad.save            AS save,
        ad.show            AS show
   FROM cat_accounts      ad
   JOIN cat_accountgroups ag ON ag.id = ad.ag_id
  WHERE ad.active = TRUE
  ORDER BY ag.rank || ad.rank;