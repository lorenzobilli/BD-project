CREATE SCHEMA IF NOT EXISTS online_challenge_activity;
SET SCHEMA 'online_challenge_activity';

CREATE TABLE IF NOT EXISTS set_icone
(
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE IF NOT EXISTS gioco
(
    id SERIAL,
    num_dadi INT NOT NULL,
    val_min_dadi INT NOT NULL,
    val_max_dadi INT NOT NULL,
    nome_set_icone VARCHAR(100) NOT NULL,
    CONSTRAINT num_dadi_min CHECK (num_dadi >= 1),
    CONSTRAINT val_dadi_min CHECK (val_min_dadi BETWEEN 0 AND 5),
    CONSTRAINT val_dadi_max CHECK (val_max_dadi BETWEEN 1 AND 6),
    CHECK (val_min_dadi <= val_max_dadi),
    PRIMARY KEY (id),
    FOREIGN KEY (nome_set_icone) REFERENCES set_icone(nome)
);

CREATE TABLE IF NOT EXISTS icona
(
    nome VARCHAR(100) NOT NULL,
    percorso VARCHAR(255) NOT NULL,
    dim_x INT NOT NULL,
    dim_y INT NOT NULL,
    nome_set_icone VARCHAR(100) NOT NULL,
    PRIMARY KEY (nome),
    FOREIGN KEY (nome_set_icone) REFERENCES set_icone(nome)
);

CREATE TABLE IF NOT EXISTS sfida
(
    id SERIAL,
    data_sfida DATE NOT NULL,
    ora_sfida TIME NOT NULL,
    moderata BOOLEAN,
    durata INTERVAL NOT NULL,
    durata_max INTERVAL NOT NULL,
    max_squadre INT NOT NULL,
    id_gioco SERIAL,
    CHECK (max_squadre >= 2),
    CONSTRAINT sfida_durata_max CHECK (durata <= durata_max),
    PRIMARY KEY (id),
    FOREIGN KEY (id_gioco) REFERENCES gioco(id)
);

CREATE TABLE IF NOT EXISTS squadra
(
    nome VARCHAR(50) NOT NULL,
    punteggio INT DEFAULT 0 NOT NULL,
    numero_dadi INT DEFAULT 0 NOT NULL,
    valore_dadi INT DEFAULT 0 NOT NULL,
    id_sfida INT NOT NULL,
    nome_icona VARCHAR(100),
    CHECK (valore_dadi >= 0),
    PRIMARY KEY (nome, id_sfida),
    FOREIGN KEY (id_sfida) REFERENCES sfida(id),
    FOREIGN KEY (nome_icona) REFERENCES icona(nome)
);

CREATE TABLE IF NOT EXISTS sfondo
(
    nome VARCHAR(50) NOT NULL,
    percorso VARCHAR(255) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE IF NOT EXISTS tabellone
(
    id_gioco INT NOT NULL,
    nome_sfondo VARCHAR(50) NOT NULL,
    PRIMARY KEY (id_gioco),
    FOREIGN KEY (id_gioco) REFERENCES gioco(id),
    FOREIGN KEY (nome_sfondo) REFERENCES sfondo(nome)
);

CREATE TABLE IF NOT EXISTS podio
(
    id_tabellone INT NOT NULL,
    PRIMARY KEY (id_tabellone),
    FOREIGN KEY (id_tabellone) REFERENCES tabellone(id_gioco)
);

CREATE TABLE IF NOT EXISTS gradino
(
    numero INT NOT NULL,
    id_podio INT NOT NULL,
    pos_x INT NOT NULL,
    pos_y INT NOT NULL,
    nome_icona VARCHAR(100),
    CHECK (numero BETWEEN 1 AND 3),
    PRIMARY KEY (numero, id_podio),
    FOREIGN KEY (id_podio) REFERENCES podio(id_tabellone),
    FOREIGN KEY (nome_icona) REFERENCES icona(nome)
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
    PRIMARY KEY (nome)
);

CREATE TABLE IF NOT EXISTS task
(
    id SERIAL NOT NULL,
    testo VARCHAR(1000) NOT NULL,
    tempo_max INTERVAL NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS risposta_task
(
    id SERIAL NOT NULL,
    id_task INT NOT NULL,
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
    PRIMARY KEY (nome)
);

CREATE TABLE IF NOT EXISTS quiz
(
    id SERIAL,
    testo VARCHAR(1000) NOT NULL,
    tempo_max INTERVAL NOT NULL,
    nome_immagine VARCHAR(50),
    PRIMARY KEY (id),
    FOREIGN KEY (nome_immagine) REFERENCES immagine(nome)
);

CREATE TABLE IF NOT EXISTS risposta_quiz
(
    id SERIAL,
    id_quiz INT NOT NULL,
    testo VARCHAR(1000) NOT NULL,
    punteggio INT NOT NULL,
    corretta BOOLEAN NOT NULL,
    nome_immagine VARCHAR(50),
    PRIMARY KEY (id, id_quiz),
    FOREIGN KEY (id_quiz) REFERENCES quiz(id),
    FOREIGN KEY (nome_immagine) REFERENCES immagine(nome)
);

CREATE TABLE IF NOT EXISTS casella
(
    num_ord INT NOT NULL,
    id_gioco INT NOT NULL,
    pos_x INT NOT NULL,
    pos_y INT NOT NULL,
    lancio_dadi BOOLEAN NOT NULL,
    id_tabellone INT NOT NULL,
    nome_video VARCHAR(50),
    id_task INT,
    id_quiz INT,
    nome_icona VARCHAR(100),
    PRIMARY KEY (num_ord, id_gioco),
    FOREIGN KEY (id_gioco) REFERENCES gioco(id),
    FOREIGN KEY (id_tabellone) REFERENCES tabellone(id_gioco),
    FOREIGN KEY (nome_video) REFERENCES video(nome),
    FOREIGN KEY (id_task) REFERENCES task(id),
    FOREIGN KEY (id_quiz) REFERENCES quiz(id),
    FOREIGN KEY (nome_icona) REFERENCES icona(nome)
);

CREATE TABLE IF NOT EXISTS casella_serpente
(
    num_ord_casella INT NOT NULL,
    id_gioco_casella SERIAL,
    destinazione INT NOT NULL,
    id_gioco_casella_destinazione SERIAL,
    CHECK (destinazione < num_ord_casella),
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
    CHECK (destinazione > num_ord_casella),
    PRIMARY KEY (num_ord_casella, id_gioco_casella),
    FOREIGN KEY (num_ord_casella, id_gioco_casella) REFERENCES casella(num_ord, id_gioco),
    FOREIGN KEY (destinazione, id_gioco_casella) REFERENCES casella(num_ord, id_gioco)
);

CREATE TABLE IF NOT EXISTS giocatore_appartiene_squadra
(
    email_giocatore VARCHAR(50) NOT NULL,
    nome_squadra VARCHAR(50) NOT NULL,
    id_sfida INT NOT NULL,
    PRIMARY KEY (email_giocatore, nome_squadra, id_sfida),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email),
    FOREIGN KEY (nome_squadra, id_sfida) REFERENCES squadra(nome, id_sfida)
);

CREATE TABLE IF NOT EXISTS giocatore_fornisce_risposta_task
(
    email_giocatore VARCHAR(50) NOT NULL,
    id_task SERIAL,
    id_risposta_task SERIAL,
    tempo_impiegato INTERVAL NOT NULL,
    PRIMARY KEY (email_giocatore, id_task, id_risposta_task),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email),
    FOREIGN KEY (id_task, id_risposta_task) REFERENCES risposta_task(id_task, id)
);

CREATE TABLE IF NOT EXISTS giocatore_fornisce_risposta_quiz
(
    email_giocatore VARCHAR(50) NOT NULL,
    id_quiz SERIAL,
    id_risposta_quiz SERIAL,
    tempo_impiegato INTERVAL NOT NULL,
    PRIMARY KEY (email_giocatore, id_quiz, id_risposta_quiz),
    FOREIGN KEY (email_giocatore) REFERENCES giocatore(email),
    FOREIGN KEY (id_quiz, id_risposta_quiz) REFERENCES risposta_quiz(id_quiz, id)
);

CREATE TABLE IF NOT EXISTS caposquadra_fornisce_risposta_task
(
    email_caposquadra VARCHAR(50) NOT NULL,
    id_task SERIAL,
    id_risposta_task SERIAL,
    tempo_impiegato INTERVAL NOT NULL,
    PRIMARY KEY (email_caposquadra, id_task, id_risposta_task),
    FOREIGN KEY (email_caposquadra) REFERENCES caposquadra(email_giocatore),
    FOREIGN KEY (id_task, id_risposta_task) REFERENCES risposta_task(id_task, id)
);

CREATE TABLE IF NOT EXISTS caposquadra_fornisce_risposta_quiz
(
    email_caposquadra VARCHAR(50) NOT NULL,
    id_quiz SERIAL,
    id_risposta_quiz SERIAL,
    tempo_impiegato INTERVAL NOT NULL,
    PRIMARY KEY (email_caposquadra, id_quiz, id_risposta_quiz),
    FOREIGN KEY (email_caposquadra) REFERENCES caposquadra(email_giocatore),
    FOREIGN KEY (id_quiz, id_risposta_quiz) REFERENCES risposta_quiz(id_quiz, id)
);
