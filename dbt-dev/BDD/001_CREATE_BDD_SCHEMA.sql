/*###########################################################*/
/* 1. VÉRIFICATION ET CRÉATION DE LA BASE DE DONNÉES (BDD)  #*/
/*###########################################################*/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'SOCCER')
BEGIN
    CREATE DATABASE SOCCER;
    PRINT 'La base de données SOCCER a été créée.';
END
ELSE
BEGIN
    PRINT 'La base de données SOCCER existe déjà.';
END
GO

/*###############################################*/
/* 2. POSITIONNEMENT ET CRÉATION DU SCHÉMA      #*/
/*###############################################*/

/* Positionne le contexte sur la BDD SOCCER pour le lot suivant */
USE SOCCER;
GO

/* Vérifie l'existence du schéma dans la BDD SOCCER */
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'CHAMPIONS_LEAGUE')
BEGIN
    /* Utilisation de EXEC() pour contourner la restriction de "batch"  de l'instruction CREATE SCHEMA */
    EXEC('CREATE SCHEMA CHAMPIONS_LEAGUE');
    PRINT 'Le schéma CHAMPIONS_LEAGUE a été créé dans la BDD SOCCER.';
END
ELSE
BEGIN
    PRINT 'Le schéma CHAMPIONS_LEAGUE existe déjà.';
END
GO
