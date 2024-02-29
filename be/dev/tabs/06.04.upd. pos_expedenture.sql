-- Tabelle update
UPDATE pos_expenditures AS pe
   SET pd_id = (SELECT pd.id
                   FROM cat_posts AS pd
                  WHERE pd.designation = pe.pd_dsg);


-- Tabelle alter
ALTER TABLE pos_expenditures
DROP COLUMN pd_dsg;