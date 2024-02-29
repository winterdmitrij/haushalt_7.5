SELECT  rank, 
        prd,
        ta_id,
        ta_dsg,
        pg_id, 
        pg_dsg, 
        pd_id, 
        pd_dsg, 
        sld
FROM   (SELECT  "0"               AS rank, 
                gbv.prd           AS prd, 
                0                 AS ta_id, 
                ""                AS ta_dsg,
                0                 AS pg_id, 
                ""                AS pg_dsg, 
                0                 AS pd_id, 
                "Insgesamt:"      AS pd_dsg, 
                SUM(gbv.amt)      AS sld
        FROM   (grb_operations_v  AS gbv 
        INNER   JOIN cat_posts_v  AS cpv ON cpv.pd_id = gbv.pd_id)
        GROUP BY LEFT(cpv.rank, 1),
                 gbv.prd
        UNION ALL
        SELECT  LEFT(cpv.rank, 1) AS rank, 
                gbv.prd           AS prd, 
                cpv.ta_id         AS ta_id, 
                cpv.ta_dsg        AS ta_dsg,
                0                 AS pg_id, 
                ""                AS pg_dsg, 
                0                 AS pd_id, 
                "Insgesamt " &
                cpv.ta_dsg & ":"  AS pd_dsg, 
                SUM(gbv.amt)      AS sld
        FROM   (grb_operations_v  AS gbv 
        INNER   JOIN cat_posts_v  AS cpv ON cpv.pd_id = gbv.pd_id)
        GROUP BY LEFT(cpv.rank, 1),
                 gbv.prd,
                 cpv.ta_id,
                 cpv.ta_dsg
        UNION ALL
        SELECT  LEFT(cpv.rank, 2) AS rank, 
                gbv.prd           AS prd,
                cpv.ta_id         AS ta_id, 
                cpv.ta_dsg        AS ta_dsg, 
                cpv.pg_id         AS pg_id, 
                cpv.pg_dsg        AS pg_dsg, 
                0                 AS pd_id, 
                "Gesamt " & 
                cpv.pg_dsg & ":"  AS pd_dsg, 
                SUM(gbv.amt)      AS sld
        FROM   (grb_operations_v  AS gbv 
        INNER   JOIN cat_posts_v  AS cpv ON cpv.pd_id = gbv.pd_id)
        GROUP BY LEFT(cpv.rank, 2),
                 gbv.prd,
                 cpv.ta_id,
                 cpv.ta_dsg,
                 cpv.pg_id,
                 cpv.pg_dsg
        UNION ALL
        SELECT  cpv.rank          AS rank, 
                gbv.prd           AS prd,
                cpv.ta_id         AS ta_id, 
                cpv.ta_dsg        AS ta_dsg,
                cpv.pg_id         AS pg_id, 
                cpv.pg_dsg        AS pg_dsg, 
                cpv.pd_id         AS pd_id, 
                "- " & cpv.pd_dsg AS pd_dsg, 
                SUM(gbv.amt)      AS sld
        FROM   (grb_operations_v  AS gbv 
        INNER   JOIN cat_posts_v  AS cpv ON cpv.pd_id = gbv.pd_id)
        GROUP BY cpv.rank,
                 gbv.prd,
                 cpv.ta_id,
                 cpv.ta_dsg,
                 cpv.pg_id,
                 cpv.pg_dsg,
                 cpv.pd_id,
                 cpv.pd_dsg
       )
ORDER   BY prd, rank;
