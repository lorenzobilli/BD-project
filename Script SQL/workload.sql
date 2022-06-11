SET SCHEMA 'online_challenge_activity';

--
-- Query specificate come carico di lavoro del DBMS
--

-- Determinare l'identificatore dei giochi che coinvolgono al più quattro squadre e richiedono l'uso di due dadi.
SELECT DISTINCT id_gioco FROM sfida
JOIN gioco g ON sfida.id_gioco = g.id
WHERE max_squadre <= 4 AND num_dadi = 2
ORDER BY id_gioco;


-- Determinare l'identificatore delle sfide relative al gioco con identificatore 17 che, in alternativa:
-- - Hanno avuto luogo a gennaio 2021 e durata massima superiore a 2 ore o
-- - Hanno avuto luogo a marzo 2021 e durata massima pari a 30 minuti.
SELECT id FROM sfida
WHERE
    (id_gioco = 17 AND (data_sfida > '2021-01-01' AND data_sfida < '2021-02-01') AND durata_max > INTERVAL '2' HOUR)
    OR
    (id_gioco = 17 AND (data_sfida > '2021-03-01' AND data_sfida < '2021-04-01') AND durata_max = INTERVAL '30' MINUTE)
ORDER BY id;


-- Determinare le sfide, di durata massima superiore a 2 ore, dei giochi che richiedono almeno due dadi.
-- Restituire sia l'identificatore della sfida sia l'identificatore del gioco.
SELECT id_gioco, sfida.id AS id_sfida FROM sfida
JOIN gioco g ON sfida.id_gioco = g.id
WHERE durata_max > INTERVAL '2' HOUR AND num_dadi >= 2
ORDER BY id_gioco;


--
-- Stesse query specificate come carico di lavoro, eseguite tramite 'EXPLAIN', per individuare il piano di esecuzione.
--

-- Determinare l'identificatore dei giochi che coinvolgono al più quattro squadre e richiedono l'uso di due dadi.
EXPLAIN (ANALYSE TRUE, VERBOSE TRUE, COSTS TRUE, BUFFERS TRUE, TIMING TRUE)
SELECT DISTINCT id_gioco FROM sfida
JOIN gioco g ON sfida.id_gioco = g.id
WHERE max_squadre <= 4 AND num_dadi = 2
ORDER BY id_gioco;


-- Determinare l'identificatore delle sfide relative al gioco con identificatore 17 che, in alternativa:
-- - Hanno avuto luogo a gennaio 2021 e durata massima superiore a 2 ore o
-- - Hanno avuto luogo a marzo 2021 e durata massima pari a 30 minuti.
EXPLAIN (ANALYSE TRUE, VERBOSE TRUE, COSTS TRUE, BUFFERS TRUE, TIMING TRUE)
SELECT id FROM sfida
WHERE
    (id_gioco = 17 AND (data_sfida > '2021-01-01' AND data_sfida < '2021-02-01') AND durata_max > INTERVAL '2' HOUR)
    OR
    (id_gioco = 17 AND (data_sfida > '2021-03-01' AND data_sfida < '2021-04-01') AND durata_max = INTERVAL '30' MINUTE)
ORDER BY id;


-- Determinare le sfide, di durata massima superiore a 2 ore, dei giochi che richiedono almeno due dadi.
-- Restituire sia l'identificatore della sfida sia l'identificatore del gioco.
EXPLAIN (ANALYSE TRUE, VERBOSE TRUE, COSTS TRUE, BUFFERS TRUE, TIMING TRUE)
SELECT id_gioco, sfida.id AS id_sfida FROM sfida
JOIN gioco g ON sfida.id_gioco = g.id
WHERE durata_max > INTERVAL '2' HOUR AND num_dadi >= 2
ORDER BY id_gioco;
