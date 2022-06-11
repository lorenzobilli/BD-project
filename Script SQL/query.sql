SET SCHEMA 'online_challenge_activity';

-- Determinare i giochi che contegono caselle a cui sono associati task.
SELECT DISTINCT id_gioco FROM casella
WHERE id_task IS NOT NULL
ORDER BY id_gioco;

-- Determinare i giochi che non contengono caselle a cui sono associati task.
SELECT DISTINCT id_gioco FROM casella
WHERE id_task IS NULL
ORDER BY id_gioco;

-- Determinare le sfide che hanno durata superiore alla durata media delle sfide relative allo stesso gioco.
SELECT id FROM sfida WHERE durata >
    (SELECT AVG(durata) FROM sfida as sfida_subquery
    WHERE sfida_subquery.id_gioco = sfida.id_gioco)
ORDER BY id;
