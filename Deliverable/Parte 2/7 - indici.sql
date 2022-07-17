-- ------------------------------------------------------------------
-- Basi di Dati A.A. 2020-2021 - Progetto 'Online Challenge Activity
--
-- Lorenzo Billi (3930391
-- ------------------------------------------------------------------

SET SCHEMA 'online_challenge_activity';

CREATE INDEX ordina_dadi ON gioco(num_dadi);
CLUSTER gioco USING ordina_dadi;

CREATE INDEX ordina_date ON sfida(data_sfida);

CREATE INDEX ordina_durata_max ON sfida(durata_max);
CLUSTER sfida USING ordina_durata_max;

CREATE INDEX ordina_max_squadre ON sfida(max_squadre);
