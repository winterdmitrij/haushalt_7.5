-- Tabelle update
UPDATE pos_banks AS pb
   SET pd_id = (SELECT pd.id
                  FROM cat_posts AS pd
                 WHERE pd.designation = pb.pd_dsg);


-- Tabelle alter
ALTER TABLE pos_banks
DROP COLUMN pd_dsg;