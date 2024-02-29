-- Tabelle update
UPDATE pos_incomes AS pi
   SET pd_id = (SELECT pd.id
                  FROM cat_posts AS pd
                 WHERE pd.designation = pi.pd_dsg);


-- Tabelle alter
ALTER TABLE pos_incomes
DROP COLUMN pd_dsg;