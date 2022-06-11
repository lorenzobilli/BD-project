SET SCHEMA 'online_challenge_activity';

-- Funzione 3A: Determina le sfide che hanno durata superiore alla durata medie delle sfide
-- di un dato gioco, prendendo come parametro l'ID del gioco.
CREATE OR REPLACE FUNCTION sfide_durata_maggiore_media(param_id_gioco INT)
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

-- Funzione 3B: Scelta dell'icona da parte di una squadra in una sfida: possono essere scelte
-- solo le icone corrispondenti al gioco cui si riferisce la sfida che non siano già state
-- scelte da altre squadre.
CREATE OR REPLACE FUNCTION scegli_icona_squadra(param_nome_squadra VARCHAR(50), param_id_sfida INT, param_nome_icona VARCHAR(100))
RETURNS BOOLEAN
LANGUAGE plpgsql
AS
    $$
    DECLARE
        icona_trovata VARCHAR(100);
        operazione_riuscita BOOL;
    BEGIN
        SELECT INTO icona_trovata FROM gioco
        JOIN sfida ON gioco.id = sfida.id_gioco
        JOIN set_icone s ON gioco.nome_set_icone = s.nome
        JOIN icona i ON s.nome = i.nome_set_icone
        WHERE i.nome = param_nome_icona AND sfida.id = param_id_sfida;
        IF NOT FOUND THEN
            operazione_riuscita = false;
            RETURN operazione_riuscita;
        ELSE
            operazione_riuscita = true;
        END IF;
        SELECT nome_icona INTO icona_trovata FROM squadra
        WHERE nome_icona = param_nome_icona;
        IF FOUND THEN
            operazione_riuscita = false;
            RETURN operazione_riuscita;
        ELSE
            UPDATE squadra
            SET nome_icona = param_nome_icona
            WHERE squadra.nome = param_nome_squadra AND squadra.id_sfida = param_id_sfida;
            operazione_riuscita = true;
            RETURN operazione_riuscita;
        END IF;
    END;
    $$;


-- Chiamate alle funzioni definite sopra

-- Funzione 3A
SELECT sfide_durata_maggiore_media(1) AS id_sfida;

-- Funzione 3B - Operazione riuscita: nessuna altra squadra ha come icona 'leone' nella sfida con ID 0
SELECT scegli_icona_squadra('GenovaSuperba', 0, 'leone');

-- Funzione 3B - Operazione non riuscita: una squadra ha gia' l'icona 'leone' nella sfida con ID 0
SELECT scegli_icona_squadra('Gramoland', 0, 'leone');

-- Funzione 3B - Operazione non riuscita: l'icona selezionata non fa parte del set di icone usato dal gioco a cui appartiene la sfida con ID 0
SELECT scegli_icona_squadra('Gorfiville', 0, 'mucca');