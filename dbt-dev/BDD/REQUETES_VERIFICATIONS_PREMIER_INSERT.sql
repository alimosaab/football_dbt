--STADES
select count(*) from CHAMPIONS_LIGUE.STADES;  -- 29
select * from CHAMPIONS_LIGUE.STADES;

--JOUEURS
select count(*) from CHAMPIONS_LIGUE.JOUEURS; -- 620
select * from CHAMPIONS_LIGUE.JOUEURS;

--JOURNEES
select count(*) from CHAMPIONS_LIGUE.JOURNEES; -- 780 26*30
select * from CHAMPIONS_LIGUE.JOURNEES;

--EQUIPES
select count(*) from CHAMPIONS_LIGUE.EQUIPES; -- 31
select * from CHAMPIONS_LIGUE.EQUIPES;

--POSTES_REFERENCE
select count(*) from CHAMPIONS_LIGUE.POSTES_REFERENCE; -- 4
select * from CHAMPIONS_LIGUE.POSTES_REFERENCE;

--TYPES_BUTS_REFERENCE
select count(*) from CHAMPIONS_LIGUE.TYPES_BUTS_REFERENCE; -- 10
select * from CHAMPIONS_LIGUE.TYPES_BUTS_REFERENCE;

--ENTRAINEURS
select count(*) from CHAMPIONS_LIGUE.ENTRAINEURS; -- 50
select * from CHAMPIONS_LIGUE.ENTRAINEURS;

--SAISONS
select count(*) from CHAMPIONS_LIGUE.SAISONS; -- 26
select * from CHAMPIONS_LIGUE.SAISONS;

--1. Vérification du volume par Saison (Joueurs) 620 joueurs à chaque saison sans exception.
SELECT saison_id, COUNT(*) AS nb_joueurs
FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON
GROUP BY saison_id
ORDER BY saison_id;


--3. Répartition des joueurs par Club (Saison 1) mapping initial a bien fonctionné pour les 31 clubs.
SELECT E.nomEquipe, COUNT(JES.joueur_id) AS nb_joueurs
FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON JES
JOIN CHAMPIONS_LIGUE.EQUIPES E ON JES.equipe_id = E.equipe_id
WHERE JES.saison_id = 1
GROUP BY E.nomEquipe
ORDER BY nb_joueurs DESC;

/* Détecter les doublons d'effectifs
Vérifier qu'un joueur n'est pas enregistré deux fois dans la même saison (ce qui fausserait tes stats).*/
SELECT joueur_id, saison_id, COUNT(*)
FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON
GROUP BY joueur_id, saison_id
HAVING COUNT(*) > 1;

SELECT 
    J.joueur_id,
    J.prenomJoueur,
    J.nomJoueur,
    J.poste_id,
    J.paysJoueur,
    E.nomEquipe,
    S.annee_debut AS Saison
FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON JES
JOIN CHAMPIONS_LIGUE.JOUEURS J ON JES.joueur_id = J.joueur_id
JOIN CHAMPIONS_LIGUE.EQUIPES E ON JES.equipe_id = E.equipe_id
JOIN CHAMPIONS_LIGUE.SAISONS S ON JES.saison_id = S.saison_id
WHERE E.abreviation = 'PSG' 
  AND JES.saison_id = 1
ORDER BY J.joueur_id;
