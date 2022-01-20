CREATE SCHEMA IF NOT EXISTS sfide_online;
SET SCHEMA 'sfide_online';

CREATE TABLE IF NOT EXISTS gioco
(
    id SERIAL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS set_icone
(
    nome VARCHAR(50) NOT NULL,
    id_gioco SERIAL,
    PRIMARY KEY (nome),
    FOREIGN KEY (id_gioco) REFERENCES gioco(id)
);

CREATE TABLE IF NOT EXISTS icona
(
    nome VARCHAR(50) NOT NULL,
    percorso VARCHAR(255) NOT NULL,
    dim_x INT NOT NULL,
    dim_y INT NOT NULL,
    nome_set_icone VARCHAR(50) NOT NULL,
    PRIMARY KEY (nome, percorso),
    FOREIGN KEY (nome_set_icone) REFERENCES set_icone(nome)
);

CREATE TABLE IF NOT EXISTS sfida
(
    data DATE NOT NULL,
    ora TIME NOT NULL,
    moderata BOOLEAN,
    durata_max INTERVAL NOT NULL,
    num_dadi INT NOT NULL,
    id_gioco SERIAL,
    PRIMARY KEY (data, ora),
    FOREIGN KEY (id_gioco) REFERENCES gioco(id)
);

CREATE TABLE IF NOT EXISTS squadra
(
    nome VARCHAR(50) NOT NULL,
    data_sfida DATE NOT NULL,
    ora_sfida TIME NOT NULL,
    punteggio INT NOT NULL,
    nome_icona VARCHAR(50) NOT NULL,
    percorso_icona VARCHAR(255) NOT NULL,
    PRIMARY KEY (nome, data_sfida, ora_sfida),
    FOREIGN KEY (data_sfida, ora_sfida) REFERENCES sfida(data, ora),
    FOREIGN KEY (nome_icona, percorso_icona) REFERENCES icona(nome, percorso),
    UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS dado
(
    id SERIAL,
    valore_min INT NOT NULL,
    valore_max INT NOT NULL,
    nome_squadra VARCHAR(50),
    PRIMARY KEY (id),
    FOREIGN KEY (nome_squadra) REFERENCES squadra(nome)
);

CREATE TABLE IF NOT EXISTS sfondo
(
    nome VARCHAR(50) NOT NULL,
    percorso VARCHAR(255) NOT NULL,
    PRIMARY KEY (nome, percorso)
);

CREATE TABLE IF NOT EXISTS tabellone
(
    id_gioco SERIAL,
    nome_sfondo VARCHAR(50) NOT NULL,
    percorso_sfondo VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_gioco),
    FOREIGN KEY (nome_sfondo, percorso_sfondo) REFERENCES sfondo(nome, percorso)
);

CREATE TABLE IF NOT EXISTS podio
(
    id_tabellone SERIAL,
    PRIMARY KEY (id_tabellone),
    FOREIGN KEY (id_tabellone) REFERENCES tabellone(id_gioco)
);

CREATE TABLE IF NOT EXISTS gradino
(
    numero INT NOT NULL,
    id_podio SERIAL,
    pos_x INT NOT NULL,
    pos_y INT NOT NULL,
    nome_squadra VARCHAR(50) NOT NULL,
    PRIMARY KEY (numero, id_podio),
    FOREIGN KEY (id_podio) REFERENCES podio(id_tabellone),
    FOREIGN KEY (nome_squadra) REFERENCES squadra(nome)
);

CREATE TABLE IF NOT EXISTS giocatore
(
    email VARCHAR(50) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    data_nascita DATE,
    PRIMARY KEY (email),
    UNIQUE (nickname)
);

CREATE TABLE IF NOT EXISTS coach
(
    email_giocatore VARCHAR(50) NOT NULL,
    PRIMARY KEY (email_giocatore),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email)
);

CREATE TABLE IF NOT EXISTS caposquadra
(
    email_giocatore VARCHAR(50) NOT NULL,
    PRIMARY KEY (email_giocatore),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email)
);

CREATE TABLE IF NOT EXISTS admin
(
    email VARCHAR(50) NOT NULL,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    data_nascita DATE,
    PRIMARY KEY (email)
);

CREATE TABLE IF NOT EXISTS video
(
    nome VARCHAR(50) NOT NULL,
    percorso VARCHAR(255) NOT NULL,
    PRIMARY KEY (nome, percorso)
);

CREATE TABLE IF NOT EXISTS task
(
    id SERIAL,
    tempo_max INTERVAL NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS risposta_task
(
    id SERIAL,
    id_task SERIAL,
    testo VARCHAR(1000) NOT NULL,
    punteggio INT NOT NULL,
    percorso_file VARCHAR(255),
    email_admin VARCHAR(50),
    email_coach VARCHAR(50),
    email_caposquadra VARCHAR(50),
    PRIMARY KEY (id, id_task),
    FOREIGN KEY (id_task) REFERENCES task(id),
    FOREIGN KEY (email_admin) REFERENCES admin(email),
    FOREIGN KEY (email_coach) REFERENCES coach(email_giocatore),
    FOREIGN KEY (email_caposquadra) REFERENCES caposquadra(email_giocatore)
);

CREATE TABLE IF NOT EXISTS immagine
(
    nome VARCHAR(50) NOT NULL,
    percorso VARCHAR(255) NOT NULL,
    PRIMARY KEY (nome, percorso)
);

CREATE TABLE IF NOT EXISTS quiz
(
    id SERIAL,
    tempo_max INTERVAL NOT NULL,
    nome_immagine VARCHAR(50),
    percorso_immagine VARCHAR(255),
    PRIMARY KEY (id),
    FOREIGN KEY (nome_immagine, percorso_immagine) REFERENCES immagine(nome, percorso)
);

CREATE TABLE IF NOT EXISTS risposta_quiz
(
    id SERIAL,
    id_quiz SERIAL,
    testo VARCHAR(1000) NOT NULL,
    punteggio INT NOT NULL,
    corretta BOOLEAN NOT NULL,
    nome_immagine VARCHAR(50),
    percorso_immagine VARCHAR(255),
    PRIMARY KEY (id, id_quiz),
    FOREIGN KEY (id_quiz) REFERENCES quiz(id),
    FOREIGN KEY (nome_immagine, percorso_immagine) REFERENCES immagine(nome, percorso)
);

CREATE TABLE IF NOT EXISTS casella
(
    num_ord INT NOT NULL,
    id_gioco SERIAL,
    pos_x INT NOT NULL,
    pos_y INT NOT NULL,
    lancio_dadi BOOLEAN NOT NULL,
    id_tabellone SERIAL,
    nome_video VARCHAR(50),
    percorso_video VARCHAR(255),
    id_task SERIAL,
    id_quiz SERIAL,
    PRIMARY KEY (num_ord, id_gioco),
    FOREIGN KEY (id_tabellone) REFERENCES tabellone(id_gioco),
    FOREIGN KEY (nome_video, percorso_video) REFERENCES video(nome, percorso),
    FOREIGN KEY (id_task) REFERENCES task(id),
    FOREIGN KEY (id_quiz) REFERENCES quiz(id)
);

CREATE TABLE IF NOT EXISTS casella_serpente
(
    num_ord_casella INT NOT NULL,
    id_gioco_casella SERIAL,
    destinazione INT NOT NULL,
    id_gioco_casella_destinazione SERIAL,
    PRIMARY KEY (num_ord_casella, id_gioco_casella),
    FOREIGN KEY (num_ord_casella, id_gioco_casella) REFERENCES casella(num_ord, id_gioco),
    FOREIGN KEY (destinazione, id_gioco_casella_destinazione) REFERENCES casella(num_ord, id_gioco)
);

CREATE TABLE IF NOT EXISTS casella_scala
(
    num_ord_casella INT NOT NULL,
    id_gioco_casella SERIAL,
    destinazione INT NOT NULL,
    id_gioco_casella_destinazione SERIAL,
    PRIMARY KEY (num_ord_casella, id_gioco_casella),
    FOREIGN KEY (num_ord_casella, id_gioco_casella) REFERENCES casella(num_ord, id_gioco),
    FOREIGN KEY (destinazione, id_gioco_casella) REFERENCES casella(num_ord, id_gioco)
);

CREATE TABLE IF NOT EXISTS giocatore_appartiene_squadra
(
    email_giocatore VARCHAR(50) NOT NULL,
    nome_squadra VARCHAR(50) NOT NULL,
    PRIMARY KEY (email_giocatore, nome_squadra),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email),
    FOREIGN KEY (nome_squadra) REFERENCES squadra(nome)
);

CREATE TABLE IF NOT EXISTS squadra_partecipa_sfida
(
    nome_squadra VARCHAR(50) NOT NULL,
    data_sfida DATE NOT NULL,
    ora_sfida TIME NOT NULL,
    min_squadre INT NOT NULL,
    max_squadre INT NOT NULL,
    PRIMARY KEY (nome_squadra, data_sfida, ora_sfida),
    FOREIGN KEY (nome_squadra) REFERENCES squadra(nome),
    FOREIGN KEY (data_sfida, ora_sfida) REFERENCES sfida(data, ora)
);

CREATE TABLE IF NOT EXISTS giocatore_fornisce_risposta_task
(
    email_giocatore VARCHAR(50) NOT NULL,
    id_task SERIAL,
    id_risposta_task SERIAL,
    tempo_impiegato INTERVAL,
    PRIMARY KEY (email_giocatore, id_task, id_risposta_task),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email),
    FOREIGN KEY (id_task, id_risposta_task) REFERENCES risposta_task(id_task, id)
);

CREATE TABLE IF NOT EXISTS giocatore_fornisce_risposta_quiz
(
    email_giocatore VARCHAR(50) NOT NULL,
    id_quiz SERIAL,
    id_risposta_quiz SERIAL,
    tempo_impiegato INTERVAL,
    PRIMARY KEY (email_giocatore, id_quiz, id_risposta_quiz),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email),
    FOREIGN KEY (id_quiz, id_risposta_quiz) REFERENCES risposta_quiz(id_quiz, id)
);

CREATE TABLE IF NOT EXISTS caposquadra_fornisce_risposta_task
(
    email_caposquadra VARCHAR(50) NOT NULL,
    id_task SERIAL,
    id_risposta_task SERIAL,
    tempo_impiegato INTERVAL,
    PRIMARY KEY (email_caposquadra, id_task, id_risposta_task),
    FOREIGN KEY (email_caposquadra) REFERENCES caposquadra(email_giocatore),
    FOREIGN KEY (id_task, id_risposta_task) REFERENCES risposta_task(id_task, id)
);

CREATE TABLE IF NOT EXISTS caposquadra_fornisce_risposta_quiz
(
    email_caposquadra VARCHAR(50) NOT NULL,
    id_quiz SERIAL,
    id_risposta_quiz SERIAL,
    tempo_impiegato INTERVAL,
    PRIMARY KEY (email_caposquadra, id_quiz, id_risposta_quiz),
    FOREIGN KEY (email_caposquadra) REFERENCES caposquadra(email_giocatore),
    FOREIGN KEY (id_quiz, id_risposta_quiz) REFERENCES risposta_quiz(id_quiz, id)
);
