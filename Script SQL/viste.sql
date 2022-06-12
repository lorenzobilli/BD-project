SET SCHEMA 'online_challenge_activity';

-- Vista ausiliaria: visualizza numero sfide per ogni gioco.
CREATE OR REPLACE VIEW status_giochi_numero_sfide AS
    SELECT id_gioco, COUNT(id) AS numero_sfide FROM sfida
    GROUP BY id_gioco;

-- Vista ausiliaria: visualizza durata media delle sfide per ogni gioco.
CREATE OR REPLACE VIEW status_giochi_sfide_durata_media AS
    SELECT id_gioco, id AS id_sfida, durata_media FROM sfida
    JOIN (SELECT id_gioco AS id_gioco_subquery, AVG(durata) AS durata_media FROM sfida
         GROUP BY id_gioco) AS sfida_subquery
    ON sfida.id_gioco = sfida_subquery.id_gioco_subquery;

-- Vista ausiliaria: visualizza numero squadre partecipanti a tutte sfide per ogni gioco.
CREATE OR REPLACE VIEW status_giochi_numero_squadre AS
    SELECT id_gioco, numero_squadre FROM sfida
    JOIN (SELECT id_sfida, COUNT(*) AS numero_squadre FROM squadra
          GROUP BY id_sfida) AS squadra_subquery
    ON sfida.id = squadra_subquery.id_sfida;

-- Vista ausiliaria: visualizza numero giocatori partecipanti a tutte le sfide per ogni gioco.
CREATE OR REPLACE VIEW status_giochi_numero_giocatori AS
    SELECT id_gioco, SUM(numero_giocatori_sfida) AS numero_giocatori FROM sfida
    JOIN (SELECT id_sfida, nome FROM squadra) AS squadra_subquery
    ON sfida.id = squadra_subquery.id_sfida
    JOIN (SELECT nome_squadra, COUNT(*) AS numero_giocatori_sfida FROM giocatore_appartiene_squadra
          GROUP BY nome_squadra) AS giocatori_subquery
    ON squadra_subquery.nome = giocatori_subquery.nome_squadra
    GROUP BY id_gioco;

-- Vista ausiliaria: visualizza punteggio minimo, medio e massimo delle squadre suddivise per sfide per ogni gioco.
CREATE OR REPLACE VIEW status_giochi_punteggi_squadre AS
    SELECT id_gioco,
           SUM(squadra_minimo) AS punteggio_minimo,
           SUM(squadra_medio) AS punteggio_medio,
           SUM(squadra_massimo) AS punteggio_massimo
    FROM sfida
    JOIN (SELECT id_sfida,
          MIN(punteggio) AS squadra_minimo,
          AVG(punteggio) AS squadra_medio,
          MAX(punteggio) AS squadra_massimo
          FROM squadra
          GROUP BY id_sfida) AS punteggio_squadra_subquery
    ON sfida.id = punteggio_squadra_subquery.id_sfida
    GROUP BY id_gioco;


-- Vista che fornisce, per ogni gioco:
-- - Il numero di sfide relative a quel gioco disputate
-- - La durata media di tali sfide
-- - Il numero di squadre e di giocatori partecipanti a tali sfide
-- - I punteggi minimo, medio e massimo ottenuti dalle squadre partecipanti a tali sfide
CREATE OR REPLACE VIEW status_online_challenge_activity AS
    SELECT DISTINCT
        status_giochi_numero_sfide.id_gioco,
        numero_sfide,
        durata_media,
        numero_squadre,
        numero_giocatori,
        punteggio_minimo,
        punteggio_medio,
        punteggio_massimo
    FROM status_giochi_numero_sfide
    JOIN status_giochi_sfide_durata_media
    ON status_giochi_numero_sfide.id_gioco = status_giochi_sfide_durata_media.id_gioco
    JOIN status_giochi_numero_squadre
    ON status_giochi_sfide_durata_media.id_gioco = status_giochi_numero_squadre.id_gioco
    JOIN status_giochi_numero_giocatori
    ON status_giochi_numero_squadre.id_gioco = status_giochi_numero_giocatori.id_gioco
    JOIN status_giochi_punteggi_squadre
    ON status_giochi_numero_giocatori.id_gioco = status_giochi_punteggi_squadre.id_gioco
    ORDER BY id_gioco;