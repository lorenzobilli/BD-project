SET SCHEMA 'online_challenge_activity';

-- Query 2A: Determinare i giochi che contegono caselle a cui sono associati task.
SELECT DISTINCT id_gioco FROM casella
WHERE id_task IS NOT NULL
ORDER BY id_gioco;

-- Query 2B: Determinare i giochi che non contengono caselle a cui sono associati task.
SELECT DISTINCT id_gioco FROM casella
WHERE id_task IS NULL
ORDER BY id_gioco;

-- Query 2C: Determinare le sfide che hanno durata superiore alla durata media delle sfide relative allo stesso gioco.
SELECT id FROM sfida WHERE durata >
    (SELECT AVG(durata) FROM sfida AS sfida_subquery
    WHERE sfida_subquery.id_gioco = sfida.id_gioco)
ORDER BY id;
