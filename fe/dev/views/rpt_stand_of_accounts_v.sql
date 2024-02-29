SELECT rng, kgbez, kdbez, beg, inc, exp, tra, bal, end
FROM (
    SELECT kg.rng + kd.rng                                      AS rng, 
           kg.bez                                               AS kgbez, 
           kd.id                                                AS kdid, 
           kd.bez                                               AS kdbez, 
          (SELECT NZ(SUM(s1.btg), 0)           
             FROM t_grossbuch s1          
            WHERE s1.kdid = kd.id            
              AND Format(s1.dtm,'yymm') < get_cur_prd())        AS beg, 
          (SELECT NZ(SUM(s2.btg), 0)           
             FROM (((t_grossbuch AS s2            
             LEFT JOIN ht_posten AS pd ON s2.pdid = pd.id)            
             LEFT JOIN ht_postgruppen AS pg ON pd.pgid = pg.id)            
             LEFT JOIN ht_transaktionen AS ta ON pg.taid = ta.id)           
            WHERE s2.kdid = kd.id            
              AND Format(s2.dtm,'yymm') = get_cur_prd()            
              AND ta.bez = "Einkommen")                         AS inc, 
          (SELECT NZ(SUM(s3.btg), 0)           
             FROM (((t_grossbuch AS s3            
             LEFT JOIN ht_posten AS pd ON s3.pdid = pd.id)            
             LEFT JOIN ht_postgruppen AS pg ON pd.pgid = pg.id)            
             LEFT JOIN ht_transaktionen AS ta ON pg.taid = ta.id)           
             WHERE s3.kdid = kd.id            
              AND Format(s3.dtm,'yymm') = get_cur_prd()            
              AND ta.bez = "Ausgaben")                          AS exp, 
          (SELECT NZ(SUM(s4.btg), 0)           
             FROM (((t_grossbuch AS s4            
             LEFT JOIN ht_posten AS pd ON s4.pdid = pd.id)            
             LEFT JOIN ht_postgruppen AS pg ON pd.pgid = pg.id)            
             LEFT JOIN ht_transaktionen AS ta ON pg.taid = ta.id)           
            WHERE s4.kdid = kd.id            
              AND Format(s4.dtm,'yymm') = get_cur_prd()            
              AND ta.bez = "Transaktionen")                     AS tra, 
          (SELECT NZ(SUM(s5.btg), 0)           
             FROM t_grossbuch s5          
            WHERE s5.kdid = kd.id            
              AND Format(s5.dtm,'yymm') = get_cur_prd())        AS bal, 
          (SELECT NZ(SUM(s6.btg), 0)           
             FROM t_grossbuch s6          
            WHERE s6.kdid = kd.id            
              AND Format(s6.dtm,'yymm') <= get_cur_prd())       AS [end] 
      FROM ht_kontengruppen AS kg 
      LEFT JOIN ht_konten   AS kd ON kd.kgid = kg.id 
     GROUP BY kg.rng, kd.rng, kg.bez, kd.id, kd.bez)            AS balance
ORDER BY rng;