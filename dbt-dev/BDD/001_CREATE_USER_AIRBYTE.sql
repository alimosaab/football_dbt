/* 1. CRÉATION DU LOGIN (Niveau Serveur)                       */
/* ############################################################*/
USE [master];
GO

IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'airbyte_user')
BEGIN
    CREATE LOGIN [airbyte_user] WITH PASSWORD = N'Mosaab2315!', 
    CHECK_EXPIRATION = OFF, 
    CHECK_POLICY = OFF;
    PRINT 'Login airbyte_user créé.';
END
GO

/* ############################################################*/
/* 2. CRÉATION DE L'UTILISATEUR ET DROITS (Niveau Base SOCCER) */
/* ############################################################*/
USE [SOCCER];
GO

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'airbyte_user')
BEGIN
    CREATE USER [airbyte_user] FOR LOGIN [airbyte_user];
    PRINT 'Utilisateur airbyte_user créé dans la base SOCCER.';
END
GO

/* Attribution des droits de propriétaire sur la base (pour dbt/Airbyte)*/
/* Cela permet de lire, écrire et modifier le schéma CHAMPIONS_LIGUE    */
ALTER ROLE [db_owner] ADD MEMBER [airbyte_user];
PRINT 'Droits db_owner attribués à airbyte_user sur SOCCER.';
GO
