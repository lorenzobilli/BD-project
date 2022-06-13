-- ------------------------------------------------------------------
-- Basi di Dati A.A. 2020-2021 - Progetto 'Online Challenge Activity
--
-- Lorenzo Billi (3930391
-- ------------------------------------------------------------------

SET SCHEMA 'online_challenge_activity';

-- Funzione associata a trigger 4A
CREATE OR REPLACE FUNCTION esegui_controlla_giocatori_sfide()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
    $$
    DECLARE
        ora_sfida_part TIME;
        durata_max_part INTERVAL;
        ora_sfida_new TIME;
        durata_max_new INTERVAL;
    BEGIN
        IF (SELECT COUNT(*) FROM giocatore_appartiene_squadra
            WHERE email_giocatore = NEW.email_giocatore AND id_sfida = NEW.id_sfida) >= 1
            THEN
                ROLLBACK;
        END IF;
        FOR ora_sfida_part, durata_max_part IN
                SELECT ora_sfida, durata_max FROM sfida s1
                JOIN giocatore_appartiene_squadra gas ON s1.id = gas.id_sfida
                WHERE email_giocatore = NEW.email_giocatore
            LOOP
                SELECT ora_sfida INTO ora_sfida_new FROM sfida s2
                JOIN NEW ON s2.id = NEW.id_sfida;
                SELECT durata_max INTO durata_max_new FROM sfida s2
                JOIN NEW ON s2.id = NEW.id_sfida;
                IF (ora_sfida_part, durata_max_part) OVERLAPS (ora_sfida_new, durata_max_new)
                    THEN
                        ROLLBACK;
                END IF;
            END LOOP;
        RETURN NEW;
    END
    $$;

-- Trigger 4A: Verifica del vincolo che nessun utente possa partecipare a sfide contemporanee.
CREATE TRIGGER controlla_giocatori_sfide
    AFTER INSERT OR UPDATE ON giocatore_appartiene_squadra
    FOR EACH ROW
    EXECUTE PROCEDURE esegui_controlla_giocatori_sfide();

-- Funzione associata a trigger 4B
CREATE OR REPLACE FUNCTION esegui_aggiorna_classifica()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
    $$
    DECLARE
        itera_classifica CURSOR FOR
            SELECT nome FROM squadra
            ORDER BY punteggio DESC
            LIMIT 3;
        primo_posto VARCHAR(50);
        secondo_posto VARCHAR(50);
        terzo_posto VARCHAR(50);
    BEGIN
        OPEN itera_classifica;
        FETCH itera_classifica INTO primo_posto;
        FETCH itera_classifica INTO secondo_posto;
        FETCH itera_classifica INTO terzo_posto;
        UPDATE gradino
            SET nome_icona = (SELECT nome_icona FROM squadra
                                WHERE nome = primo_posto)
            WHERE numero = 1;
        UPDATE gradino
            SET nome_icona = (SELECT nome_icona FROM squadra
                                WHERE nome = secondo_posto)
            WHERE numero = 2;
        UPDATE gradino
            SET nome_icona = (SELECT nome_icona FROM squadra
                                WHERE nome = terzo_posto)
            WHERE numero = 3;
    END
    $$;

-- Trigger 4B: Mantenimento del punteggio corrente di ciascuna squadra in ogni sfida e inserimento delle icone
-- opportune nella casella podio.
CREATE TRIGGER aggiorna_classifica
    AFTER INSERT OR UPDATE ON squadra
    FOR EACH ROW
    EXECUTE PROCEDURE esegui_aggiorna_classifica();