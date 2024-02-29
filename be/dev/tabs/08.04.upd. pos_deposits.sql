-- Tabelle update
UPDATE pos_deposits AS pd
   SET ad_id = (SELECT ad.id
                  FROM cat_accounts AS ad
                 WHERE ad.designation = pd.ad_dsg);


-- Tabelle alter
ALTER TABLE pos_deposits
DROP COLUMN ad_dsg;