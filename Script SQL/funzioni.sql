SET SCHEMA 'online_challenge_activity';

-- Funzione 3A: Determina le sfide che hanno durata superiore alla durata medie delle sfide
-- di un dato gioco, prendendo come parametro l'ID del gioco.
CREATE OR REPLACE FUNCTION challenges_longer_average_duration(param_id_gioco INT)
RETURNS TABLE (id_sfida INT)
LANGUAGE plpgsql
AS
    $$
    BEGIN
        RETURN QUERY
            SELECT id FROM sfida WHERE id_gioco = param_id_gioco
            AND durata >
                (SELECT AVG(durata) FROM sfida AS sfida_subquery
                WHERE sfida_subquery.id_gioco = param_id_gioco)
            ORDER BY id;
    END;
    $$;

-- Chiamate alle funzioni definite
SELECT challenges_longer_average_duration(1);