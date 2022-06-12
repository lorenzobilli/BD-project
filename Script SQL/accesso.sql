SET SCHEMA 'online_challenge_activity';

CREATE ROLE gamecreator;
CREATE ROLE gameadmin;
CREATE ROLE giocatore;
CREATE ROLE utente;

GRANT gameadmin TO gamecreator;
GRANT utente TO giocatore;

GRANT SELECT, INSERT, UPDATE, DELETE ON
    gioco,
    tabellone,
    admin
TO gamecreator;

GRANT SELECT, INSERT, UPDATE, DELETE ON
    sfida,
    risposta_task,
    squadra,
    giocatore
TO gameadmin;

GRANT INSERT, UPDATE ON
    squadra,
    giocatore,
    caposquadra,
    coach,
    caposquadra_fornisce_risposta_task,
    caposquadra_fornisce_risposta_quiz,
    giocatore_fornisce_risposta_task,
    giocatore_fornisce_risposta_quiz
TO giocatore;

GRANT SELECT ON
    status_online_challenge_activity,
    status_giochi_sfide_durata_media,
    status_giochi_numero_squadre,
    status_giochi_numero_giocatori,
    status_giochi_punteggi_squadre
TO utente;