-- #############################################
-- 1. PRÉPARATION ET NETTOYAGE
-- #############################################
USE SOCCER;
GO

DECLARE @SaisonID INT = 1; 
DECLARE @NbEquipes INT = 16;
DECLARE @ProbCSC FLOAT = 0.01;
DECLARE @ProbPenalty FLOAT = 0.05;

/* NETTOYAGE DES DONNÉES (Ordre inverse des FK) */
--DELETE FROM CHAMPIONS_LIGUE.BUTS WHERE saison_id= @SaisonID;;
--DELETE FROM CHAMPIONS_LIGUE.MATCHS WHERE saison_id= @SaisonID;;
DELETE FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON WHERE saison_id= @SaisonID;
DELETE FROM CHAMPIONS_LIGUE.ENTRAINEURS_EQUIPE_SAISON WHERE saison_id= @SaisonID;;
DELETE FROM CHAMPIONS_LIGUE.JOURNEES;
DELETE FROM CHAMPIONS_LIGUE.EQUIPES;
DELETE FROM CHAMPIONS_LIGUE.JOUEURS;
DELETE FROM CHAMPIONS_LIGUE.ENTRAINEURS;
DELETE FROM CHAMPIONS_LIGUE.STADES;
DELETE FROM CHAMPIONS_LIGUE.POSTES_REFERENCE;
DELETE FROM CHAMPIONS_LIGUE.TYPES_BUTS_REFERENCE;
DELETE FROM CHAMPIONS_LIGUE.SAISONS;

-- Réinitialisation des compteurs IDENTITY
DBCC CHECKIDENT ('CHAMPIONS_LIGUE.JOUEURS', RESEED, 0);
DBCC CHECKIDENT ('CHAMPIONS_LIGUE.ENTRAINEURS', RESEED, 0);
DBCC CHECKIDENT ('CHAMPIONS_LIGUE.STADES', RESEED, 0);
DBCC CHECKIDENT ('CHAMPIONS_LIGUE.SAISONS', RESEED, 0);
--DBCC CHECKIDENT ('CHAMPIONS_LIGUE.MATCHS', RESEED, 0);
GO

-- #############################################
-- 2. REMPLISSAGE DES RÉFÉRENTIELS
-- #############################################

/* TABLE STADES (Identity) */
SET IDENTITY_INSERT CHAMPIONS_LIGUE.STADES ON;
INSERT INTO CHAMPIONS_LIGUE.STADES (stade_id, nomStade, villeStade, paysStade, capacite) VALUES
(1, 'Parc des Princes', 'Paris', 'FRANCE', 47929),
(2, 'Stade Vélodrome', 'Marseille', 'FRANCE', 67394),
(3, 'Stade Bollaert-Delelis', 'Lens', 'FRANCE', 38223),
(4, 'Santiago Bernabéu', 'Madrid', 'ESPAGNE', 81044),
(5, 'Camp Nou', 'Barcelone', 'ESPAGNE', 99354),
(6, 'Complexe Mohammed V', 'Casablanca', 'MAROC', 67000),
(7, 'Old Trafford', 'Manchester', 'ANGLETERRE', 74310),
(8, 'Etihad Stadium', 'Manchester', 'ANGLETERRE', 53400), 
(9, 'Anfield', 'Liverpool', 'ANGLETERRE', 53394), 
(10, 'Allianz Arena', 'Munich', 'ALLEMAGNE', 75000),
(11, 'Signal Iduna Park', 'Dortmund', 'ALLEMAGNE', 81365), 
(12, 'Johan Cruyff Arena', 'Amsterdam', 'PAYS-BAS', 55500), 
(13, 'Philips Stadion', 'Eindhoven', 'PAYS-BAS', 35000), 
(14, 'San Siro', 'Milan', 'ITALIE', 80018), 
(15, 'Allianz Stadium', 'Turin', 'ITALIE', 41507),
(16, 'Stadio Diego Armando Maradona', 'Naples', 'ITALIE', 54726), 
(17, 'Estádio da Luz', 'Lisbonne', 'PORTUGAL', 64642),
(18, 'Estádio do Dragão', 'Porto', 'PORTUGAL', 50033), 
(19, 'Apostolos Nikolaidis', 'Athènes', 'GRÈCE', 16000),
(20, 'RAMS Park', 'Istanbul', 'TURQUIE', 52652),
(21, 'Şükrü Saracoğlu Stadium', 'Istanbul', 'TURQUIE', 47834),
(22, 'Arena Lviv', 'Lviv', 'UKRAINE', 34915),
(23, 'Stade Olympique', 'Kiev', 'UKRAINE', 70050), 
(24, 'Lotto Park', 'Bruxelles', 'BELGIQUE', 21500),
(25, 'Jan Breydel Stadium', 'Bruges', 'BELGIQUE', 29042),
(26, 'Celtic Park', 'Glasgow', 'ÉCOSSE', 60411),
(27, 'Ibrox Stadium', 'Glasgow', 'ÉCOSSE', 50817),
(28, 'St. Jakob-Park', 'Bâle', 'SUISSE', 38512),
(29, 'Red Bull Arena', 'Salzbourg', 'AUTRICHE', 31400);
SET IDENTITY_INSERT CHAMPIONS_LIGUE.STADES OFF;

/* TABLE POSTES_REFERENCE */
INSERT INTO CHAMPIONS_LIGUE.POSTES_REFERENCE (poste_id, nomPoste) VALUES
(1, 'Gardien'), (2, 'Défenseur'), (3, 'Milieu'), (4, 'Attaquant');

/* TABLE TYPES_BUTS_REFERENCE */
INSERT INTO CHAMPIONS_LIGUE.TYPES_BUTS_REFERENCE (type_but_id, nom_type_but) VALUES
(1, 'Pied'), (2, 'Tête'), (3, 'Penalty'), (4, 'Coup Franc Direct'),
(5, 'Coup Franc Indirect'), (6, 'Corner'), (7, 'CSC'), (8, 'Autre'),
(9, 'Corner Direct'),(10, 'Corner Indirect');

/* TABLE ENTRAINEURS (Identity) */
SET IDENTITY_INSERT CHAMPIONS_LIGUE.ENTRAINEURS ON;
INSERT INTO CHAMPIONS_LIGUE.ENTRAINEURS (entraineur_id, nomEntraineur, prenomEntraineur, paysEntraineur) VALUES
(1, 'Guardiola', 'Pep', 'Espagnole'), (2, 'Klopp', 'Jürgen', 'Allemande'), (3, 'Mourinho', 'José', 'Portugaise'),
(4, 'Ancelotti', 'Carlo', 'Italienne'), (5, 'Zidane', 'Zinédine', 'Française'), (6, 'Simeone', 'Diego', 'Argentine'),
(7, 'Tuchel', 'Thomas', 'Allemande'), (8, 'Allegri', 'Massimiliano', 'Italienne'), (9, 'Pochettino', 'Mauricio', 'Argentine'),
(10, 'Emery', 'Unai', 'Espagnole'), (11, 'Ten Hag', 'Erik', 'Néerlandaise'), (12, 'Spalletti', 'Luciano', 'Italienne'),
(13, 'Conte', 'Antonio', 'Italienne'), (14, 'Nagelsmann', 'Julian', 'Allemande'), (15, 'Galtier', 'Christophe', 'Française'),
(16, 'Sarri', 'Maurizio', 'Italienne'), (17, 'Löw', 'Joachim', 'Allemande'), (18, 'Deschamps', 'Didier', 'Française'),
(19, 'Bielsa', 'Marcelo', 'Argentine'), (20, 'Flick', 'Hansi', 'Allemande'), (21, 'Xavi', 'Hernández', 'Espagnole'),
(22, 'Ferguson', 'Alex', 'Écossaise'), (23, 'Wenger', 'Arsène', 'Française'), (24, 'Sacchi', 'Arrigo', 'Italienne'),
(25, 'Cruyff', 'Johan', 'Néerlandaise'), (26, 'Hitzfeld', 'Ottmar', 'Allemande'), (27, 'Heynckes', 'Jupp', 'Allemande'),
(28, 'Trapattoni', 'Giovanni', 'Italienne'), (29, 'Capello', 'Fabio', 'Italienne'), (30, 'Benítez', 'Rafael', 'Espagnole'),
(31, 'Ranieri', 'Claudio', 'Italienne'), (32, 'Lippi', 'Marcello', 'Italienne'), (33, 'Rehhagel', 'Otto', 'Allemande'),
(34, 'van Gaal', 'Louis', 'Néerlandaise'), (35, 'Hiddink', 'Guus', 'Néerlandaise'), (36, 'Löpez', 'Javier', 'Espagnole'),
(37, 'Sampaoli', 'Jorge', 'Argentine'), (38, 'Mancini', 'Roberto', 'Italienne'), (39, 'Setién', 'Quique', 'Espagnole'),
(40, 'Bosz', 'Peter', 'Néerlandaise'), (41, 'Villas-Boas', 'André', 'Portugaise'), (42, 'Rudi', 'Garcia', 'Française'),
(43, 'Hasenhüttl', 'Ralph', 'Autrichienne'), (44, 'Bilic', 'Slaven', 'Croate'), (45, 'Martínez', 'Roberto', 'Espagnole'),
(46, 'Pioli', 'Stefano', 'Italienne'), (47, 'Fonseca', 'Paulo', 'Portugaise'), (48, 'Rodgers', 'Brendan', 'Nord-irlandaise'),
(49, 'Berti', 'Vogts', 'Allemande'), (50, 'Southgate', 'Gareth', 'Anglaise');
SET IDENTITY_INSERT CHAMPIONS_LIGUE.ENTRAINEURS OFF;

/* TABLE SAISONS  */
SET IDENTITY_INSERT CHAMPIONS_LIGUE.SAISONS ON;
DECLARE @AnneeFin INT = YEAR(GETDATE());
WITH AnneesSeries AS (
    SELECT 2000 AS AnneeDebut, 1 AS SaisonID
    UNION ALL
    SELECT A.AnneeDebut + 1, A.SaisonID + 1 FROM AnneesSeries A WHERE A.AnneeDebut + 1 <= @AnneeFin
)
INSERT INTO CHAMPIONS_LIGUE.SAISONS (saison_id, annee_debut, annee_fin)
SELECT SaisonID, AnneeDebut, AnneeDebut + 1 FROM AnneesSeries
OPTION (MAXRECURSION 0);
SET IDENTITY_INSERT CHAMPIONS_LIGUE.SAISONS OFF;
GO

-- #############################################
-- 3. REMPLISSAGE DES TABLES LIÉES
-- #############################################

/* JOUEURS (Mapping tranches ID) */
SET IDENTITY_INSERT CHAMPIONS_LIGUE.JOUEURS ON;
INSERT INTO CHAMPIONS_LIGUE.JOUEURS (joueur_id, nomJoueur, prenomJoueur, date_naissance, poste_id, paysJoueur) VALUES

-- FRANCE (PSG) - Joueurs 1 à 20
(1, 'Donnarumma', 'Gianluigi', '1999-02-25', 1, 'ITALIE'), -- Gardien
(2, 'Hakimi', 'Achraf', '1998-11-04', 2, 'MAROC'), -- Défenseur
(3, 'Marquinhos', 'Marcos', '1994-05-14', 2, 'BRÉSIL'),
(4, 'Škriniar', 'Milan', '1995-02-11', 2, 'SLOVAQUIE'),
(5, 'Mendes', 'Nuno', '2002-06-19', 2, 'PORTUGAL'),
(6, 'Ugarte', 'Manuel', '2001-04-11', 3, 'URUGUAY'), -- Milieu
(7, 'Vitinha', 'Vitor', '2000-02-13', 3, 'PORTUGAL'),
(8, 'Zaïre-Emery', 'Warren', '2006-03-08', 3, 'FRANCE'),
(9, 'Dembélé', 'Ousmane', '1997-05-15', 4, 'FRANCE'), -- Attaquant
(10, 'Mbappé', 'Kylian', '1998-12-20', 4, 'FRANCE'),
(11, 'Kolo Muani', 'Randal', '1998-12-05', 4, 'FRANCE'),
(12, 'Navas', 'Keylor', '1986-12-15', 1, 'COSTA RICA'),
(13, 'Pereira', 'Danilo', '1991-09-09', 2, 'PORTUGAL'),
(14, 'Hernández', 'Lucas', '1996-02-14', 2, 'FRANCE'),
(15, 'Ruiz', 'Fabián', '1996-04-03', 3, 'ESPAGNE'),
(16, 'Asensio', 'Marco', '1996-01-21', 4, 'ESPAGNE'),
(17, 'Soler', 'Carlos', '1997-01-02', 3, 'ESPAGNE'),
(18, 'Lee', 'Kang-in', '2001-02-19', 3, 'CORÉE DU SUD'),
(19, 'Barcola', 'Bradley', '2002-09-02', 4, 'FRANCE'),
(20, 'Ramos', 'Gonçalo', '2001-06-20', 4, 'PORTUGAL'),

-- FRANCE (OM) - Joueurs 21 à 40
(21, 'Lopez', 'Pau', '1994-12-13', 1, 'ESPAGNE'),
(22, 'Clauss', 'Jonathan', '1992-09-25', 2, 'FRANCE'),
(23, 'Balerdi', 'Leonardo', '1999-01-26', 2, 'ARGENTINE'),
(24, 'Gigot', 'Samuel', '1993-10-12', 2, 'FRANCE'),
(25, 'Lodi', 'Renan', '1998-10-08', 2, 'BRÉSIL'),
(26, 'Rongier', 'Valentin', '1994-12-15', 3, 'FRANCE'),
(27, 'Veretout', 'Jordan', '1993-03-01', 3, 'FRANCE'),
(28, 'Harit', 'Amine', '1997-06-18', 3, 'MAROC'),
(29, 'Ndiaye', 'Iliman', '2000-03-06', 4, 'SÉNÉGAL'),
(30, 'Aubameyang', 'Pierre-Emerick', '1989-06-18', 4, 'GABON'),
(31, 'Correa', 'Joaquín', '1994-08-13', 4, 'ARGENTINE'),
(32, 'Blanco', 'Rubén', '1995-07-25', 1, 'ESPAGNE'),
(33, 'Mbemba', 'Chancel', '1994-08-08', 2, 'RDC'),
(34, 'Kolasinac', 'Sead', '1993-06-20', 2, 'BOSNIE'),
(35, 'Gueye', 'Pape', '1999-01-24', 3, 'SÉNÉGAL'),
(36, 'Sarr', 'Ismaïla', '1998-02-25', 4, 'SÉNÉGAL'),
(37, 'Ounahi', 'Azzedine', '2000-04-19', 3, 'MAROC'),
(38, 'Mughe', 'François-Régis', '2004-06-16', 4, 'CAMEROUN'),
(39, 'Tavares', 'Nuno', '2000-01-26', 2, 'PORTUGAL'),
(40, 'Vitinha', 'Vitor Manuel', '2000-03-15', 4, 'PORTUGAL'),

-- FRANCE (Lens) - Joueurs 41 à 60
(41, 'Samba', 'Brice', '1994-04-25', 1, 'FRANCE'),
(42, 'Gradit', 'Jonathan', '1992-11-24', 2, 'FRANCE'),
(43, 'Danso', 'Kevin', '1998-09-19', 2, 'AUTRICHE'),
(44, 'Medina', 'Facundo', '1999-05-28', 2, 'ARGENTINE'),
(45, 'Frankowski', 'Przemysław', '1995-04-12', 2, 'POLOGNE'),
(46, 'Abdul Samed', 'Salis', '2000-03-26', 3, 'GHANA'),
(47, 'Diouf', 'Andy', '2003-05-17', 3, 'FRANCE'),
(48, 'Thomasson', 'Adrien', '1993-12-10', 3, 'FRANCE'),
(49, 'Sotoca', 'Florian', '1990-10-25', 4, 'FRANCE'),
(50, 'Wahi', 'Elye', '2003-01-02', 4, 'FRANCE'),
(51, 'Fulgini', 'Angelo', '1996-08-25', 4, 'FRANCE'),
(52, 'Leca', 'Jean-Louis', '1985-09-21', 1, 'FRANCE'),
(53, 'Machado', 'Deiver', '1993-09-02', 2, 'COLOMBIE'),
(54, 'Haïdara', 'Massadio', '1992-12-02', 2, 'MALI'),
(55, 'Mendyl', 'Achraf', '1997-06-18', 2, 'MAROC'),
(56, 'El Aynaoui', 'Neil', '2001-07-02', 3, 'MAROC'),
(57, 'Costa', 'David Pereira da', '2001-01-05', 3, 'PORTUGAL'),
(58, 'Guilavogui', 'Morgan', '2000-07-10', 4, 'FRANCE'),
(59, 'Khusanov', 'Abdukodir', '2004-02-29', 2, 'OUZBÉKISTAN'),
(60, 'Cortés', 'Óscar', '2003-12-03', 4, 'COLOMBIE'),

-- ESPAGNE (Real Madrid) - Joueurs 61 à 80
(61, 'Courtois', 'Thibaut', '1992-05-11', 1, 'BELGIQUE'),
(62, 'Carvajal', 'Dani', '1992-01-11', 2, 'ESPAGNE'),
(63, 'Militão', 'Éder', '1998-01-18', 2, 'BRÉSIL'),
(64, 'Alaba', 'David', '1992-06-24', 2, 'AUTRICHE'),
(65, 'Mendy', 'Ferland', '1995-06-08', 2, 'FRANCE'),
(66, 'Camavinga', 'Eduardo', '2002-11-10', 3, 'FRANCE'),
(67, 'Tchouaméni', 'Aurélien', '2000-01-27', 3, 'FRANCE'),
(68, 'Bellingham', 'Jude', '2003-06-29', 3, 'ANGLETERRE'),
(69, 'Valverde', 'Federico', '1998-07-22', 3, 'URUGUAY'),
(70, 'Vinícius Júnior', 'Vinícius', '2000-07-12', 4, 'BRÉSIL'),
(71, 'Rodrygo', 'Rodrygo', '2001-01-09', 4, 'BRÉSIL'),
(72, 'Lunin', 'Andriy', '1999-02-11', 1, 'UKRAINE'),
(73, 'Nacho', 'José', '1990-01-18', 2, 'ESPAGNE'),
(74, 'Rüdiger', 'Antonio', '1993-03-03', 2, 'ALLEMAGNE'),
(75, 'Kroos', 'Toni', '1990-01-04', 3, 'ALLEMAGNE'),
(76, 'Modrić', 'Luka', '1985-09-09', 3, 'CROATIE'),
(77, 'Díaz', 'Brahim', '1999-08-03', 4, 'ESPAGNE'),
(78, 'Güler', 'Arda', '2005-02-25', 3, 'TURQUIE'),
(79, 'Joselu', 'José Luis', '1990-03-27', 4, 'ESPAGNE'),
(80, 'Ceballos', 'Dani', '1996-08-07', 3, 'ESPAGNE'),

-- ESPAGNE (FC Barcelone) - Joueurs 81 à 100
(81, 'Ter Stegen', 'Marc-André', '1992-04-30', 1, 'ALLEMAGNE'),
(82, 'Koundé', 'Jules', '1998-11-12', 2, 'FRANCE'),
(83, 'Araújo', 'Ronald', '1999-03-07', 2, 'URUGUAY'),
(84, 'Christensen', 'Andreas', '1996-04-10', 2, 'DANEMARK'),
(85, 'Balde', 'Alejandro', '2003-10-18', 2, 'ESPAGNE'),
(86, 'De Jong', 'Frenkie', '1997-05-05', 3, 'PAYS-BAS'),
(87, 'Gavi', 'Pablo Martín', '2004-08-05', 3, 'ESPAGNE'),
(88, 'Pedri', 'Pedro', '2002-11-25', 3, 'ESPAGNE'),
(89, 'Raphinha', 'Raphael', '1996-12-14', 4, 'BRÉSIL'),
(90, 'Lewandowski', 'Robert', '1988-08-21', 4, 'POLOGNE'),
(91, 'Félix', 'João', '1999-11-10', 4, 'PORTUGAL'),
(92, 'Peña', 'Iñaki', '1999-03-02', 1, 'ESPAGNE'),
(93, 'Cancelo', 'João', '1994-05-27', 2, 'PORTUGAL'),
(94, 'Martínez', 'Iñigo', '1991-05-17', 2, 'ESPAGNE'),
(95, 'Romeu', 'Oriol', '1991-09-24', 3, 'ESPAGNE'),
(96, 'Gündoğan', 'İlkay', '1990-10-24', 3, 'ALLEMAGNE'),
(97, 'Torres', 'Ferran', '2000-02-29', 4, 'ESPAGNE'),
(98, 'Yamal', 'Lamine', '2007-07-13', 4, 'ESPAGNE'),
(99, 'Fati', 'Ansu', '2002-10-31', 4, 'ESPAGNE'),
(100, 'Alonso', 'Marcos', '1990-12-28', 2, 'ESPAGNE'),

-- MAROC (Wydad AC) - Joueurs 101 à 120
(101, 'El Motie', 'Youssef', '1995-12-23', 1, 'MAROC'),
(102, 'El Amloud', 'Ayoub', '1994-04-08', 2, 'MAROC'),
(103, 'Aboulfath', 'Yahia', '1996-01-09', 2, 'MAROC'),
(104, 'Haimoud', 'Hamza', '1996-06-15', 2, 'MAROC'),
(105, 'Attiat Allah', 'Yahia', '1995-03-02', 2, 'MAROC'),
(106, 'Jabrane', 'Yahya', '1991-06-18', 3, 'MAROC'),
(107, 'Hassouni', 'Aymane', '1995-02-22', 3, 'MAROC'),
(108, 'Daoudi', 'Reda', '1995-09-22', 3, 'MAROC'),
(109, 'El Bahri', 'Bouly Junior', '1998-05-25', 4, 'MAROC'),
(110, 'Moutaraji', 'Zouhair', '1996-01-08', 4, 'MAROC'),
(111, 'Serrhat', 'Saifeddine', '1994-11-10', 4, 'MAROC'),
(112, 'Sioudi', 'Taha', '1993-01-01', 1, 'MAROC'),
(113, 'Koumami', 'Amine', '1996-07-07', 2, 'MAROC'),
(114, 'Dari', 'Achraf', '1999-05-06', 2, 'MAROC'),
(115, 'Boulahroud', 'Wali', '1995-01-01', 3, 'MAROC'),
(116, 'Badi', 'Anas', '1998-03-15', 3, 'MAROC'),
(117, 'Benyachou', 'Hicham', '1997-03-08', 4, 'MAROC'),
(118, 'Oukadi', 'Youssef', '2000-11-11', 4, 'MAROC'),
(119, 'Lamkel Ze', 'Didier', '1996-09-17', 4, 'CAMEROUN'),
(120, 'Benayad', 'Aymen', '1998-08-01', 2, 'MAROC'),

-- MAROC (Raja CA) - Joueurs 121 à 140
(121, 'Zouhair', 'Anas', '1998-02-15', 1, 'MAROC'),
(122, 'Harkass', 'Jamal', '1995-06-03', 2, 'MAROC'),
(123, 'Madkour', 'Abdelilah', '1997-09-15', 2, 'MAROC'),
(124, 'Aziz', 'Youssef', '1998-01-20', 2, 'MAROC'),
(125, 'Bentayg', 'Mohamed', '1998-02-05', 2, 'MAROC'),
(126, 'Al Makahasi', 'Mohamed', '1995-10-15', 3, 'MAROC'),
(127, 'Zerhouni', 'Omar', '1996-03-10', 3, 'MAROC'),
(128, 'Benjdida', 'Zakaria', '2000-01-01', 4, 'MAROC'),
(129, 'Boutayeb', 'Khalid', '1997-05-15', 4, 'MAROC'),
(130, 'Moutouali', 'Mohsine', '1986-03-03', 3, 'MAROC'),
(131, 'Hadhoudi', 'Marouane', '1991-02-13', 2, 'MAROC'),
(132, 'Zniti', 'Anas', '1988-10-20', 1, 'MAROC'),
(133, 'Soukhane', 'Amir', '1996-04-05', 2, 'MAROC'),
(134, 'Aholou', 'Jean', '1995-04-13', 3, 'CÔTE D''IVOIRE'),
(135, 'Kouko', 'Lamine', '1996-01-01', 3, 'CÔTE D''IVOIRE'),
(136, 'Bouzok', 'Mohamed', '1999-01-15', 4, 'MAROC'),
(137, 'Benzaid', 'Zakaria', '1997-01-01', 4, 'MAROC'),
(138, 'Hadraf', 'Zakaria', '1990-09-20', 4, 'MAROC'),
(139, 'Ngoma', 'Fabrice', '1998-07-22', 3, 'RDC'),
(140, 'Fahli', 'Hamid', '1999-03-25', 2, 'MAROC'),

-- ANGLETERRE (Manchester United) - Joueurs 141 à 160
(141, 'Onana', 'André', '1996-04-02', 1, 'CAMEROUN'),
(142, 'Dalot', 'Diogo', '1999-03-18', 2, 'PORTUGAL'),
(143, 'Varane', 'Raphaël', '1993-04-25', 2, 'FRANCE'),
(144, 'Martínez', 'Lisandro', '1998-01-18', 2, 'ARGENTINE'),
(145, 'Shaw', 'Luke', '1995-07-12', 2, 'ANGLETERRE'),
(146, 'Casemiro', 'Carlos Henrique', '1992-02-23', 3, 'BRÉSIL'),
(147, 'Fernandes', 'Bruno', '1994-09-08', 3, 'PORTUGAL'),
(148, 'Mount', 'Mason', '1999-01-10', 3, 'ANGLETERRE'),
(149, 'Rashford', 'Marcus', '1997-10-31', 4, 'ANGLETERRE'),
(150, 'Højlund', 'Rasmus', '2003-02-04', 4, 'DANEMARK'),
(151, 'Antony', 'Antony Matheus', '2000-02-24', 4, 'BRÉSIL'),
(152, 'Bayindir', 'Altay', '1998-04-14', 1, 'TURQUIE'),
(153, 'Maguire', 'Harry', '1993-03-05', 2, 'ANGLETERRE'),
(154, 'Lindelöf', 'Victor', '1994-07-17', 2, 'SUÈDE'),
(155, 'Eriksen', 'Christian', '1992-02-14', 3, 'DANEMARK'),
(156, 'McTominay', 'Scott', '1996-12-08', 3, 'ÉCOSSE'),
(157, 'Garnacho', 'Alejandro', '2004-07-01', 4, 'ARGENTINE'),
(158, 'Martial', 'Anthony', '1995-12-05', 4, 'FRANCE'),
(159, 'Mainoo', 'Kobbie', '2005-04-19', 3, 'ANGLETERRE'),
(160, 'Wan-Bissaka', 'Aaron', '1997-11-26', 2, 'ANGLETERRE'),

-- ANGLETERRE (Manchester City) - Joueurs 161 à 180
(161, 'Ederson', 'Santana de Moraes', '1993-08-17', 1, 'BRÉSIL'),
(162, 'Walker', 'Kyle', '1990-05-28', 2, 'ANGLETERRE'),
(163, 'Dias', 'Rúben', '1997-05-14', 2, 'PORTUGAL'),
(164, 'Stones', 'John', '1994-05-28', 2, 'ANGLETERRE'),
(165, 'Gvardiol', 'Joško', '2002-01-23', 2, 'CROATIE'),
(166, 'Rodri', 'Rodrigo', '1996-06-22', 3, 'ESPAGNE'),
(167, 'Silva', 'Bernardo', '1994-08-10', 3, 'PORTUGAL'),
(168, 'De Bruyne', 'Kevin', '1991-06-28', 3, 'BELGIQUE'),
(169, 'Foden', 'Phil', '2000-05-28', 4, 'ANGLETERRE'),
(170, 'Haaland', 'Erling', '2000-07-21', 4, 'NORVÈGE'),
(171, 'Álvarez', 'Julián', '2000-01-31', 4, 'ARGENTINE'),
(172, 'Ortega', 'Stefan', '1992-11-06', 1, 'ALLEMAGNE'),
(173, 'Aké', 'Nathan', '1995-02-18', 2, 'PAYS-BAS'),
(174, 'Laporte', 'Aymeric', '1994-05-27', 2, 'ESPAGNE'),
(175, 'Kovacic', 'Mateo', '1994-05-06', 3, 'CROATIE'),
(176, 'Grealish', 'Jack', '1995-09-10', 4, 'ANGLETERRE'),
(177, 'Doku', 'Jérémy', '2002-05-27', 4, 'BELGIQUE'),
(178, 'Phillips', 'Kalvin', '1995-12-02', 3, 'ANGLETERRE'),
(179, 'Nunes', 'Matheus', '1998-08-27', 3, 'PORTUGAL'),
(180, 'Lewis', 'Rico', '2004-11-21', 2, 'ANGLETERRE'),

-- ANGLETERRE (Liverpool FC) - Joueurs 181 à 200
(181, 'Alisson', 'Ramses', '1992-10-02', 1, 'BRÉSIL'),
(182, 'Alexander-Arnold', 'Trent', '1998-10-07', 2, 'ANGLETERRE'),
(183, 'Konaté', 'Ibrahima', '1999-05-25', 2, 'FRANCE'),
(184, 'Van Dijk', 'Virgil', '1991-07-08', 2, 'PAYS-BAS'),
(185, 'Robertson', 'Andrew', '1994-03-11', 2, 'ÉCOSSE'),
(186, 'Szoboszlai', 'Dominik', '2000-10-25', 3, 'HONGRIE'),
(187, 'Mac Allister', 'Alexis', '1998-12-24', 3, 'ARGENTINE'),
(188, 'Thiago', 'Alcântara', '1991-04-11', 3, 'ESPAGNE'),
(189, 'Salah', 'Mohamed', '1992-06-15', 4, 'ÉGYPTE'),
(190, 'Núñez', 'Darwin', '1999-06-24', 4, 'URUGUAY'),
(191, 'Díaz', 'Luis', '1997-01-13', 4, 'COLOMBIE'),
(192, 'Kelleher', 'Caoimhín', '1998-11-23', 1, 'IRLANDE'),
(193, 'Gomez', 'Joe', '1997-05-25', 2, 'ANGLETERRE'),
(194, 'Tsimikas', 'Kostas', '1996-05-12', 2, 'GRÈCE'),
(195, 'Jones', 'Curtis', '2001-01-30', 3, 'ANGLETERRE'),
(196, 'Endo', 'Wataru', '1993-02-09', 3, 'JAPON'),
(197, 'Jota', 'Diogo', '1996-12-04', 4, 'PORTUGAL'),
(198, 'Gakpo', 'Cody', '1999-05-07', 4, 'PAYS-BAS'),
(199, 'Elliott', 'Harvey', '2003-04-04', 3, 'ANGLETERRE'),
(200, 'Matip', 'Joël', '1991-08-08', 2, 'CAMEROUN'),

-- ALLEMAGNE (Bayern Munich) - Joueurs 201 à 220
(201, 'Neuer', 'Manuel', '1986-03-27', 1, 'ALLEMAGNE'),
(202, 'Davies', 'Alphonso', '2000-11-02', 2, 'CANADA'),
(203, 'De Ligt', 'Matthijs', '1999-08-12', 2, 'PAYS-BAS'),
(204, 'Upamecano', 'Dayot', '1998-10-27', 2, 'FRANCE'),
(205, 'Mazraoui', 'Noussair', '1997-11-14', 2, 'MAROC'),
(206, 'Kimmich', 'Joshua', '1995-02-08', 3, 'ALLEMAGNE'),
(207, 'Goretzka', 'Leon', '1995-02-06', 3, 'ALLEMAGNE'),
(208, 'Musiala', 'Jamal', '2003-02-26', 3, 'ALLEMAGNE'),
(209, 'Sané', 'Leroy', '1996-01-11', 4, 'ALLEMAGNE'),
(210, 'Kane', 'Harry', '1993-07-28', 4, 'ANGLETERRE'),
(211, 'Coman', 'Kingsley', '1996-06-13', 4, 'FRANCE'),
(212, 'Ulreich', 'Sven', '1988-08-03', 1, 'ALLEMAGNE'),
(213, 'Min-jae', 'Kim', '1996-11-15', 2, 'CORÉE DU SUD'),
(214, 'Guerreiro', 'Raphaël', '1993-12-22', 2, 'PORTUGAL'),
(215, 'Laimer', 'Konrad', '1997-05-27', 3, 'AUTRICHE'),
(216, 'Müller', 'Thomas', '1989-09-13', 4, 'ALLEMAGNE'),
(217, 'Tel', 'Mathys', '2005-04-27', 4, 'FRANCE'),
(218, 'Choupo-Moting', 'Eric Maxim', '1989-03-23', 4, 'CAMEROUN'),
(219, 'Gnabry', 'Serge', '1995-07-09', 4, 'ALLEMAGNE'),
(220, 'Pavard', 'Benjamin', '1996-03-29', 2, 'FRANCE'),

-- ALLEMAGNE (Borussia Dortmund) - Joueurs 221 à 240
(221, 'Kobel', 'Gregor', '1997-12-06', 1, 'SUISSE'),
(222, 'Süle', 'Niklas', '1995-09-03', 2, 'ALLEMAGNE'),
(223, 'Hummels', 'Mats', '1988-12-16', 2, 'ALLEMAGNE'),
(224, 'Schlotterbeck', 'Nico', '1999-12-01', 2, 'ALLEMAGNE'),
(225, 'Bensebaini', 'Ramy', '1995-04-16', 2, 'ALGÉRIE'),
(226, 'Can', 'Emre', '1994-01-12', 3, 'ALLEMAGNE'),
(227, 'Brandt', 'Julian', '1996-05-02', 3, 'ALLEMAGNE'),
(228, 'Sabitzer', 'Marcel', '1994-03-17', 3, 'AUTRICHE'),
(229, 'Malen', 'Donyell', '1999-01-19', 4, 'PAYS-BAS'),
(230, 'Füllkrug', 'Niclas', '1993-02-09', 4, 'ALLEMAGNE'),
(231, 'Adeyemi', 'Karim', '2002-01-11', 4, 'ALLEMAGNE'),
(232, 'Meyer', 'Alexander', '1991-04-13', 1, 'ALLEMAGNE'),
(233, 'Ryerson', 'Julian', '1997-11-17', 2, 'NORVÈGE'),
(234, 'Wolf', 'Marius', '1995-05-27', 2, 'ALLEMAGNE'),
(235, 'Nmecha', 'Felix', '2000-10-10', 3, 'ALLEMAGNE'),
(236, 'Reus', 'Marco', '1989-05-31', 4, 'ALLEMAGNE'),
(237, 'Reyna', 'Giovanni', '2002-11-13', 3, 'ÉTATS-UNIS'),
(238, 'Moukoko', 'Youssoufa', '2004-11-20', 4, 'ALLEMAGNE'),
(239, 'Haller', 'Sébastien', '1994-06-22', 4, 'CÔTE D''IVOIRE'),
(240, 'Özcan', 'Salih', '1998-01-11', 3, 'TURQUIE'),

-- PAYS-BAS (Ajax Amsterdam) - Joueurs 241 à 260
(241, 'Rulli', 'Gerónimo', '1992-05-20', 1, 'ARGENTINE'),
(242, 'Rensch', 'Devyne', '2003-01-18', 2, 'PAYS-BAS'),
(243, 'Hato', 'Jorrel', '2006-03-07', 2, 'PAYS-BAS'),
(244, 'Šutalo', 'Josip', '2000-02-28', 2, 'CROATIE'),
(245, 'Wijndal', 'Owen', '1999-11-28', 2, 'PAYS-BAS'),
(246, 'Tahirović', 'Benjamin', '2003-03-03', 3, 'BOSNIE'),
(247, 'Berghuis', 'Steven', '1991-12-19', 3, 'PAYS-BAS'),
(248, 'Taylor', 'Kenneth', '2002-05-16', 3, 'PAYS-BAS'),
(249, 'Bergwijn', 'Steven', '1997-10-08', 4, 'PAYS-BAS'),
(250, 'Brobbey', 'Brian', '2002-02-01', 4, 'PAYS-BAS'),
(251, 'Akpom', 'Chuba', '1995-10-09', 4, 'ANGLETERRE'),
(252, 'Gorter', 'Jay', '2000-05-30', 1, 'PAYS-BAS'),
(253, 'Álvarez', 'Edson', '1997-10-24', 3, 'MEXIQUE'),
(254, 'Klaassen', 'Davy', '1993-02-21', 3, 'PAYS-BAS'),
(255, 'Kudus', 'Mohammed', '2000-08-02', 3, 'GHANA'),
(256, 'Conceição', 'Francisco', '2002-12-14', 4, 'PORTUGAL'),
(257, 'Haller', 'Sébastien', '1994-06-22', 4, 'CÔTE D''IVOIRE'),
(258, 'Daramy', 'Mohamed', '2002-01-07', 4, 'SIERRA LEONE'),
(259, 'Gooijer', 'Tristan', '2004-09-02', 2, 'PAYS-BAS'),
(260, 'Forbs', 'Carlos', '2004-03-19', 4, 'PORTUGAL'),

-- PAYS-BAS (PSV Eindhoven) - Joueurs 261 à 280
(261, 'Benítez', 'Walter', '1993-01-19', 1, 'ARGENTINE'),
(262, 'Teze', 'Jordan', '1999-07-30', 2, 'PAYS-BAS'),
(263, 'Ramalho', 'André', '1992-02-16', 2, 'BRÉSIL'),
(264, 'Boscagli', 'Olivier', '1997-11-18', 2, 'FRANCE'),
(265, 'Dest', 'Sergiño', '2000-11-03', 2, 'ÉTATS-UNIS'),
(266, 'Sangare', 'Ibrahim', '1997-12-02', 3, 'CÔTE D''IVOIRE'),
(267, 'Veerman', 'Joey', '1998-11-19', 3, 'PAYS-BAS'),
(268, 'Simons', 'Xavi', '2003-04-21', 3, 'PAYS-BAS'),
(269, 'Bakayoko', 'Johan', '2003-04-20', 4, 'BELGIQUE'),
(270, 'De Jong', 'Luuk', '1990-08-20', 4, 'PAYS-BAS'),
(271, 'Lozano', 'Hirving', '1995-07-30', 4, 'MEXIQUE'),
(272, 'Drommel', 'Joël', '1996-11-16', 1, 'PAYS-BAS'),
(273, 'Sambo', 'Shurandy', '2001-08-19', 2, 'PAYS-BAS'),
(274, 'Mauro Junior', 'Junior', '1999-05-06', 2, 'BRÉSIL'),
(275, 'Saibari', 'Ismael', '2001-01-28', 3, 'MAROC'),
(276, 'Til', 'Guus', '1997-12-22', 3, 'PAYS-BAS'),
(277, 'Pepi', 'Ricardo', '2003-01-09', 4, 'ÉTATS-UNIS'),
(278, 'Lang', 'Noa', '1999-06-17', 4, 'PAYS-BAS'),
(279, 'Babadi', 'Ismael', '2005-01-05', 3, 'PAYS-BAS'),
(280, 'Obispo', 'Armando', '1999-03-05', 2, 'PAYS-BAS'),

-- ITALIE (AC Milan) - Joueurs 281 à 300
(281, 'Maignan', 'Mike', '1995-07-03', 1, 'FRANCE'),
(282, 'Calabria', 'Davide', '1996-12-06', 2, 'ITALIE'),
(283, 'Tomori', 'Fikayo', '1997-12-19', 2, 'ANGLETERRE'),
(284, 'Thiaw', 'Malick', '2001-08-08', 2, 'ALLEMAGNE'),
(285, 'Hernández', 'Theo', '1997-10-06', 2, 'FRANCE'),
(286, 'Krunić', 'Rade', '1993-10-07', 3, 'BOSNIE'),
(287, 'Loftus-Cheek', 'Ruben', '1996-01-23', 3, 'ANGLETERRE'),
(288, 'Reijnders', 'Tijani', '1998-07-29', 3, 'PAYS-BAS'),
(289, 'Pulisic', 'Christian', '1998-09-18', 4, 'ÉTATS-UNIS'),
(290, 'Giroud', 'Olivier', '1986-09-30', 4, 'FRANCE'),
(291, 'Leão', 'Rafael', '1999-06-10', 4, 'PORTUGAL'),
(292, 'Sportiello', 'Marco', '1992-05-10', 1, 'ITALIE'),
(293, 'Kjær', 'Simon', '1989-03-26', 2, 'DANEMARK'),
(294, 'Kalulu', 'Pierre', '2000-06-05', 2, 'FRANCE'),
(295, 'Bennacer', 'Ismaël', '1997-12-01', 3, 'ALGÉRIE'),
(296, 'Adli', 'Yacine', '2000-07-29', 3, 'FRANCE'),
(297, 'Chukwueze', 'Samuel', '1999-05-22', 4, 'NIGÉRIA'),
(298, 'Okafor', 'Noah', '2000-05-24', 4, 'SUISSE'),
(299, 'Romero', 'Luka', '2004-11-18', 4, 'ARGENTINE'),
(300, 'Florenzi', 'Alessandro', '1991-03-11', 2, 'ITALIE'),

-- ITALIE (Inter Milan) - Joueurs 301 à 320
(301, 'Sommer', 'Yann', '1988-12-17', 1, 'SUISSE'),
(302, 'Darmian', 'Matteo', '1989-12-02', 2, 'ITALIE'),
(303, 'De Vrij', 'Stefan', '1992-02-05', 2, 'PAYS-BAS'),
(304, 'Bastoni', 'Alessandro', '1999-04-13', 2, 'ITALIE'),
(305, 'Dumfries', 'Denzel', '1996-04-18', 2, 'PAYS-BAS'),
(306, 'Barella', 'Nicolò', '1997-02-07', 3, 'ITALIE'),
(307, 'Calhanoglu', 'Hakan', '1994-02-08', 3, 'TURQUIE'),
(308, 'Mkhitaryan', 'Henrikh', '1989-01-21', 3, 'ARMÉNIE'),
(309, 'Dimarco', 'Federico', '1997-11-10', 2, 'ITALIE'),
(310, 'Martínez', 'Lautaro', '1997-08-22', 4, 'ARGENTINE'),
(311, 'Thuram', 'Marcus', '1997-08-06', 4, 'FRANCE'),
(312, 'Audero', 'Emil', '1997-01-18', 1, 'INDONÉSIE'),
(313, 'Pavard', 'Benjamin', '1996-03-29', 2, 'FRANCE'),
(314, 'Acerbi', 'Francesco', '1988-02-10', 2, 'ITALIE'),
(315, 'Frattesi', 'Davide', '1999-09-22', 3, 'ITALIE'),
(316, 'Asllani', 'Kristjan', '2002-03-09', 3, 'ALBANIE'),
(317, 'Arnautović', 'Marko', '1989-04-19', 4, 'AUTRICHE'),
(318, 'Sánchez', 'Alexis', '1988-12-19', 4, 'CHILI'),
(319, 'Cuadrado', 'Juan', '1988-05-30', 2, 'COLOMBIE'),
(320, 'Klaassen', 'Davy', '1993-02-21', 3, 'PAYS-BAS'),

-- ITALIE (Juventus FC) - Joueurs 321 à 340
(321, 'Szczęsny', 'Wojciech', '1990-04-18', 1, 'POLOGNE'),
(322, 'Danilo', 'Luiz', '1991-07-15', 2, 'BRÉSIL'),
(323, 'Bremer', 'Gleison', '1997-03-18', 2, 'BRÉSIL'),
(324, 'Sandro', 'Alex', '1991-01-26', 2, 'BRÉSIL'),
(325, 'Cambiaso', 'Andrea', '2000-02-20', 2, 'ITALIE'),
(326, 'Locatelli', 'Manuel', '1998-01-08', 3, 'ITALIE'),
(327, 'Rabiot', 'Adrien', '1995-04-03', 3, 'FRANCE'),
(328, 'Miretti', 'Fabio', '2003-08-03', 3, 'ITALIE'),
(329, 'Chiesa', 'Federico', '1997-10-25', 4, 'ITALIE'),
(330, 'Vlahović', 'Dušan', '2000-01-28', 4, 'SERBIE'),
(331, 'Kean', 'Moise', '2000-02-28', 4, 'ITALIE'),
(332, 'Perin', 'Mattia', '1992-11-10', 1, 'ITALIE'),
(333, 'Rugani', 'Daniele', '1994-07-29', 2, 'ITALIE'),
(334, 'De Sciglio', 'Mattia', '1992-10-20', 2, 'ITALIE'),
(335, 'McKennie', 'Weston', '1998-08-28', 3, 'ÉTATS-UNIS'),
(336, 'Fagioli', 'Nicolò', '2001-02-12', 3, 'ITALIE'),
(337, 'Kostić', 'Filip', '1992-11-01', 4, 'SERBIE'),
(338, 'Milik', 'Arkadiusz', '1994-02-28', 4, 'POLOGNE'),
(339, 'Yildiz', 'Kenan', '2005-05-04', 4, 'TURQUIE'),
(340, 'Weah', 'Timothy', '2000-02-22', 4, 'ÉTATS-UNIS'),

-- ITALIE (SSC Napoli) - Joueurs 341 à 360
(341, 'Meret', 'Alex', '1997-03-22', 1, 'ITALIE'),
(342, 'Di Lorenzo', 'Giovanni', '1993-08-04', 2, 'ITALIE'),
(343, 'Rrahmani', 'Amir', '1994-02-24', 2, 'KOSOVO'),
(344, 'Ostigard', 'Leo', '1999-11-28', 2, 'NORVÈGE'),
(345, 'Rui', 'Mário', '1991-05-27', 2, 'PORTUGAL'),
(346, 'Lobotka', 'Stanislav', '1994-11-25', 3, 'SLOVAQUIE'),
(347, 'Anguissa', 'André-Frank Zambo', '1995-11-16', 3, 'CAMEROUN'),
(348, 'Zielinski', 'Piotr', '1994-05-20', 3, 'POLOGNE'),
(349, 'Politano', 'Matteo', '1993-08-03', 4, 'ITALIE'),
(350, 'Osimhen', 'Victor', '1998-12-29', 4, 'NIGÉRIA'),
(351, 'Kvaratskhelia', 'Khvicha', '2001-02-12', 4, 'GÉORGIE'),
(352, 'Gollini', 'Pierluigi', '1995-03-18', 1, 'ITALIE'),
(353, 'Natan', 'Bernardo de Souza', '2001-02-06', 2, 'BRÉSIL'),
(354, 'Juan Jesus', 'Juan', '1991-06-03', 2, 'BRÉSIL'),
(355, 'Cajuste', 'Jens', '1999-08-10', 3, 'SUÈDE'),
(356, 'Elmas', 'Elif', '1999-09-24', 3, 'MACÉDOINE DU NORD'),
(357, 'Raspadori', 'Giacomo', '2000-02-18', 4, 'ITALIE'),
(358, 'Simeone', 'Giovanni', '1995-07-05', 4, 'ARGENTINE'),
(359, 'Zedadka', 'Karim', '2000-06-09', 2, 'ALGÉRIE'),
(360, 'Zerbin', 'Alessio', '1999-03-03', 4, 'ITALIE'),

-- PORTUGAL (SL Benfica) - Joueurs 361 à 380
(361, 'Trubin', 'Anatoliy', '2001-08-01', 1, 'UKRAINE'),
(362, 'Bah', 'Alexander', '1997-12-09', 2, 'DANEMARK'),
(363, 'Otamendi', 'Nicolás', '1988-02-12', 2, 'ARGENTINE'),
(364, 'Silva', 'António', '2003-10-30', 2, 'PORTUGAL'),
(365, 'Aursnes', 'Fredrik', '1995-12-10', 2, 'NORVÈGE'),
(366, 'João Neves', 'João', '2004-09-27', 3, 'PORTUGAL'),
(367, 'Kökçü', 'Orkun', '2000-12-29', 3, 'TURQUIE'),
(368, 'Di María', 'Ángel', '1988-02-14', 4, 'ARGENTINE'),
(369, 'Silva', 'Rafa', '1993-05-17', 4, 'PORTUGAL'),
(370, 'Musa', 'Petar', '1998-03-04', 4, 'CROATIE'),
(371, 'Tengstedt', 'Casper', '2000-06-01', 4, 'DANEMARK'),
(372, 'Soares', 'Samuel', '2000-06-15', 1, 'PORTUGAL'),
(373, 'Morato', 'Felipe', '2001-06-30', 2, 'BRÉSIL'),
(374, 'Bernat', 'Juan', '1993-03-01', 2, 'ESPAGNE'),
(375, 'Chiquinho', 'Francisco', '1995-07-19', 3, 'PORTUGAL'),
(376, 'Florentino', 'Luís', '1999-08-19', 3, 'PORTUGAL'),
(377, 'Neres', 'David', '1997-03-03', 4, 'BRÉSIL'),
(378, 'Cabral', 'Arthur', '1998-04-25', 4, 'BRÉSIL'),
(379, 'Gouveia', 'Tiago', '2001-06-18', 4, 'PORTUGAL'),
(380, 'Pêpê', 'Eduardo', '1997-02-24', 3, 'BRÉSIL'),

-- PORTUGAL (FC Porto) - Joueurs 381 à 400
(381, 'Costa', 'Diogo', '1999-09-19', 1, 'PORTUGAL'),
(382, 'Pepê', 'Eduardo', '1997-02-24', 2, 'BRÉSIL'),
(383, 'Carmo', 'David', '1999-07-19', 2, 'PORTUGAL'),
(384, 'Marcano', 'Iván', '1987-06-23', 2, 'ESPAGNE'),
(385, 'Zaidu', 'Sanusi', '1997-06-13', 2, 'NIGÉRIA'),
(386, 'Eustáquio', 'Stephen', '1996-12-21', 3, 'CANADA'),
(387, 'Varela', 'Alan', '2001-07-30', 3, 'ARGENTINE'),
(388, 'Galeno', 'Wenderson', '1997-10-21', 4, 'BRÉSIL'),
(389, 'Taremi', 'Mehdi', '1992-07-18', 4, 'IRAN'),
(390, 'Evanilson', 'Francisco', '1999-10-06', 4, 'BRÉSIL'),
(391, 'Conceição', 'Francisco', '2002-12-14', 4, 'PORTUGAL'),
(392, 'Cláudio Ramos', 'Cláudio', '1991-11-16', 1, 'PORTUGAL'),
(393, 'Fábio Cardoso', 'Fábio', '1994-04-19', 2, 'PORTUGAL'),
(394, 'João Mário', 'João', '2000-01-03', 2, 'PORTUGAL'),
(395, 'Grujić', 'Marko', '1996-04-13', 3, 'SERBIE'),
(396, 'Nico González', 'Nicolás', '2002-01-03', 3, 'ESPAGNE'),
(397, 'Toni Martínez', 'Antonio', '1997-06-30', 4, 'ESPAGNE'),
(398, 'Namaso', 'Danny', '2000-04-14', 4, 'ANGLETERRE'),
(399, 'Romário Baró', 'Romário', '2000-01-25', 3, 'PORTUGAL'),
(400, 'Wendell', 'Wendell', '1993-07-20', 2, 'BRÉSIL'),

-- GRÈCE (Panathinaikos FC) - Joueurs 401 à 420
(401, 'Brignoli', 'Alberto', '1991-06-19', 1, 'ITALIE'),
(402, 'Vagiannidis', 'Georgios', '2001-09-12', 2, 'GRÈCE'),
(403, 'Schenkeveld', 'Bart', '1991-08-28', 2, 'PAYS-BAS'),
(404, 'Jedvaj', 'Tin', '1995-11-28', 2, 'CROATIE'),
(405, 'Mladenović', 'Filip', '1991-08-15', 2, 'SERBIE'),
(406, 'Pérez', 'Rubén', '1989-04-26', 3, 'ESPAGNE'),
(407, 'Bernard', 'Bernard', '1992-09-08', 3, 'BRÉSIL'),
(408, 'Djuričić', 'Filip', '1992-01-30', 3, 'SERBIE'),
(409, 'Palacios', 'Sebastián', '1992-01-20', 4, 'ARGENTINE'),
(410, 'Ioannidis', 'Fotis', '2000-01-10', 4, 'GRÈCE'),
(411, 'Sporar', 'Andraž', '1994-02-27', 4, 'SLOVÉNIE'),
(412, 'Lodygin', 'Yury', '1990-05-26', 1, 'RUSSIE'),
(413, 'Kotsiras', 'Georgios', '1992-02-19', 2, 'GRÈCE'),
(414, 'Cokaj', 'Enis', '1999-07-11', 3, 'ALBANIE'),
(415, 'Gnezda Čerin', 'Adam', '1999-07-16', 3, 'SLOVÉNIE'),
(416, 'Mancini', 'Daniel', '1998-08-26', 4, 'ITALIE'),
(417, 'Verbič', 'Benjamin', '1993-11-27', 4, 'SLOVÉNIE'),
(418, 'Aitor', 'Cantalapiedra', '1996-02-10', 4, 'ESPAGNE'),
(419, 'Jovanovic', 'Nikola', '1998-09-08', 2, 'SERBIE'),
(420, 'Tchokai', 'Enis', '1999-07-11', 3, 'ALBANIE'),

-- TURQUIE (Galatasaray) - Joueurs 421 à 440
(421, 'Muslera', 'Fernando', '1986-06-16', 1, 'URUGUAY'),
(422, 'Günay', 'Güngör', '1991-03-29', 1, 'TURQUIE'),
(423, 'Bardakcı', 'Abdülkerim', '1994-09-07', 2, 'TURQUIE'),
(424, 'Nelsson', 'Victor', '1998-10-14', 2, 'DANEMARK'),
(425, 'Dubois', 'Léo', '1994-09-14', 2, 'FRANCE'),
(426, 'Angelino', 'José', '1997-01-04', 2, 'ESPAGNE'),
(427, 'Boey', 'Sacha', '2000-09-13', 2, 'FRANCE'),
(428, 'Torreira', 'Lucas', '1996-02-11', 3, 'URUGUAY'),
(429, 'Demirbay', 'Kerem', '1993-07-03', 3, 'ALLEMAGNE'),
(430, 'Zaniolo', 'Nicolò', '1999-07-02', 3, 'ITALIE'),
(431, 'Akturkoglu', 'Kerem', '1998-10-21', 4, 'TURQUIE'),
(432, 'Ziyech', 'Hakim', '1993-03-19', 4, 'MAROC'),
(433, 'Icardi', 'Mauro', '1993-02-19', 4, 'ARGENTINE'),
(434, 'Mertens', 'Dries', '1987-05-06', 4, 'BELGIQUE'),
(435, 'Oliveira', 'Sergio', '1992-06-13', 3, 'PORTUGAL'),
(436, 'Midtsjø', 'Fredrik', '1993-08-11', 3, 'NORVÈGE'),
(437, 'Ayhan', 'Kaan', '1994-10-10', 2, 'TURQUIE'),
(438, 'Yılmaz', 'Kazımcan', '2003-01-27', 2, 'TURQUIE'),
(439, 'Tete', 'Mateus', '2000-02-15', 4, 'BRÉSIL'),
(440, 'Bakambu', 'Cédric', '1991-04-11', 4, 'RD CONGO'),

-- TURQUIE (Fenerbahce) - Joueurs 441 à 460
(441, 'Livaković', 'Dominik', '1995-01-09', 1, 'CROATIE'),
(442, 'Bayındır', 'Altay', '1998-04-14', 1, 'TURQUIE'),
(443, 'Djiku', 'Alexander', '1994-08-09', 2, 'GHANA'),
(444, 'Oosterwolde', 'Jayden', '2001-04-26', 2, 'PAYS-BAS'),
(445, 'Osayi-Samuel', 'Bright', '1997-12-31', 2, 'NIGÉRIA'),
(446, 'Becão', 'Rodrigo', '1996-01-19', 2, 'BRÉSIL'),
(447, 'Szalai', 'Attila', '1998-01-20', 2, 'HONGRIE'),
(448, 'Szymanski', 'Sebastian', '1999-05-10', 3, 'POLOGNE'),
(449, 'Fred', 'Frederico', '1993-03-05', 3, 'BRÉSIL'),
(450, 'Yüksek', 'Ismail', '1999-01-26', 3, 'TURQUIE'),
(451, 'Tadić', 'Dušan', '1988-11-20', 4, 'SERBIE'),
(452, 'Džeko', 'Edin', '1986-03-17', 4, 'BOSNIE-HERZÉGOVINE'),
(453, 'Kahveci', 'Irfan Can', '1995-07-15', 4, 'TURQUIE'),
(454, 'Under', 'Cengiz', '1997-07-14', 4, 'TURQUIE'),
(455, 'King', 'Joshua', '1992-01-15', 4, 'NORVÈGE'),
(456, 'Muldur', 'Mert', '1999-04-13', 2, 'TURQUIE'),
(457, 'Krunić', 'Rade', '1993-10-07', 3, 'BOSNIE-HERZÉGOVINE'),
(458, 'Mert', 'Hakan Yandas', '1997-01-12', 3, 'TURQUIE'),
(459, 'Batshuayi', 'Michy', '1993-10-02', 4, 'BELGIQUE'),
(460, 'Sosa', 'José', '1985-06-25', 3, 'ARGENTINE'),

-- UKRAINE (Shakhtar Donetsk) - Joueurs 461 à 480
(461, 'Riznyk', 'Dmytro', '1999-01-30', 1, 'UKRAINE'),
(462, 'Tvardovskyi', 'Denys', '2002-06-13', 1, 'UKRAINE'),
(463, 'Matviyenko', 'Mykola', '1996-05-02', 2, 'UKRAINE'),
(464, 'Konoplia', 'Yukhym', '1999-08-26', 2, 'UKRAINE'),
(465, 'Miroshi', 'Giorgi', '2000-07-28', 2, 'GÉORGIE'),
(466, 'Rakitskyi', 'Yaroslav', '1989-08-03', 2, 'UKRAINE'),
(467, 'Topalov', 'Dmytro', '1998-03-07', 2, 'UKRAINE'),
(468, 'Stepanenko', 'Taras', '1989-08-08', 3, 'UKRAINE'),
(469, 'Sudakov', 'Georgiy', '2002-09-01', 3, 'UKRAINE'),
(470, 'Bondarenko', 'Artem', '2000-08-21', 3, 'UKRAINE'),
(471, 'Zubkov', 'Oleksandr', '1996-08-03', 4, 'UKRAINE'),
(472, 'Sikan', 'Danylo', '2001-04-16', 4, 'UKRAINE'),
(473, 'Kashchuk', 'Oleksii', '2000-01-29', 4, 'UKRAINE'),
(474, 'Eguinaldo', 'Eguinaldo', '2004-08-09', 4, 'BRÉSIL'),
(475, 'Nazaryna', 'Yehor', '1997-07-10', 3, 'UKRAINE'),
(476, 'Kryskiv', 'Dmytro', '2000-10-06', 3, 'UKRAINE'),
(477, 'Lemkin', 'Dmytro', '2003-02-23', 2, 'UKRAINE'),
(478, 'Traoré', 'Lassina', '2001-01-12', 4, 'BURKINA FASO'),
(479, 'Newerton', 'Martins', '2005-06-03', 4, 'BRÉSIL'),
(480, 'Puzankov', 'Andriy', '2003-01-02', 3, 'UKRAINE'),

-- UKRAINE (Dynamo Kiev) - Joueurs 481 à 500
(481, 'Buschan', 'Heorhiy', '1994-05-31', 1, 'UKRAINE'),
(482, 'Neshcheret', 'Ruslan', '2002-01-22', 1, 'UKRAINE'),
(483, 'Popov', 'Denys', '1999-04-17', 2, 'UKRAINE'),
(484, 'Karavaev', 'Oleksandr', '1992-06-02', 2, 'UKRAINE'),
(485, 'Tymchyk', 'Oleksandr', '1997-01-20', 2, 'UKRAINE'),
(486, 'Syrota', 'Oleksandr', '2000-06-11', 2, 'UKRAINE'),
(487, 'Dyachuk', 'Maksym', '2003-07-21', 2, 'UKRAINE'),
(488, 'Shaparenko', 'Mykola', '1998-10-04', 3, 'UKRAINE'),
(489, 'Sydorchuk', 'Serhiy', '1991-05-02', 3, 'UKRAINE'),
(490, 'Shepelev', 'Volodymyr', '1997-06-01', 3, 'UKRAINE'),
(491, 'Brailko', 'Maksym', '2002-09-02', 3, 'UKRAINE'),
(492, 'Yarmolenko', 'Andriy', '1989-10-23', 4, 'UKRAINE'),
(493, 'Vanat', 'Vladyslav', '2002-01-04', 4, 'UKRAINE'),
(494, 'Buyalskyi', 'Vitaliy', '1993-01-06', 3, 'UKRAINE'),
(495, 'Kabayev', 'Vladyslav', '1995-09-01', 4, 'UKRAINE'),
(496, 'Voloshyn', 'Nazar', '2003-06-17', 4, 'UKRAINE'),
(497, 'Malysh', 'Vitaliy', '2002-03-16', 4, 'UKRAINE'),
(498, 'Parris', 'Ben', '2000-11-20', 3, 'ANGLETERRE'),
(499, 'Kostiuk', 'Andriy', '2001-03-15', 2, 'UKRAINE'),
(500, 'Tsarenko', 'Anton', '2004-09-17', 3, 'UKRAINE'),

-- BELGIQUE (Anderlecht) - Joueurs 501 à 520
(501, 'Schmeichel', 'Kasper', '1986-11-05', 1, 'DANEMARK'),
(502, 'Dupé', 'Maxime', '1993-03-04', 1, 'FRANCE'),
(503, 'Vertonghen', 'Jan', '1987-04-24', 2, 'BELGIQUE'),
(504, 'Debast', 'Zeno', '2003-10-24', 2, 'BELGIQUE'),
(505, 'Vázquez', 'Luis', '2001-01-24', 4, 'ARGENTINE'),
(506, 'Amuzu', 'Francis', '1999-08-23', 4, 'BELGIQUE'),
(507, 'Rits', 'Mats', '1993-10-18', 3, 'BELGIQUE'),
(508, 'Hazard', 'Thorgan', '1993-03-29', 4, 'BELGIQUE'),
(509, 'Dreyer', 'Anders', '1998-05-06', 4, 'DANEMARK'),
(510, 'Leoni', 'Theo', '2000-02-21', 3, 'BELGIQUE'),
(511, 'Delaney', 'Thomas', '1991-09-03', 3, 'DANEMARK'),
(512, 'Nielsen', 'Kristoffer', '1997-05-07', 3, 'DANEMARK'),
(513, 'Sardella', 'Killian', '2002-05-02', 2, 'BELGIQUE'),
(514, 'N''Diaye', 'Moussa', '2002-02-20', 2, 'SÉNÉGAL'),
(515, 'Engwanda', 'Plamedie', '2003-12-10', 2, 'BELGIQUE'),
(516, 'Ashimeru', 'Majeed', '1997-10-10', 3, 'GHANA'),
(517, 'Stroeykens', 'Mario', '2004-09-29', 4, 'BELGIQUE'),
(518, 'Dolberg', 'Kasper', '1997-10-06', 4, 'DANEMARK'),
(519, 'Arnstad', 'Kristian', '2001-09-07', 3, 'NORVÈGE'),
(520, 'Lapage', 'Tristan', '2003-01-13', 2, 'BELGIQUE'),

-- BELGIQUE (Club Bruges) - Joueurs 521 à 540
(521, 'Mignolet', 'Simon', '1988-03-06', 1, 'BELGIQUE'),
(522, 'Jackers', 'Nick', '1999-10-15', 1, 'BELGIQUE'),
(523, 'Mechele', 'Brandon', '1993-01-28', 2, 'BELGIQUE'),
(524, 'Ordoñez', 'Joaquín', '2002-09-07', 2, 'ÉQUATEUR'),
(525, 'De Cuyper', 'Maxim', '2000-12-22', 2, 'BELGIQUE'),
(526, 'Spileers', 'Jorne', '2005-01-21', 2, 'BELGIQUE'),
(527, 'Odoi', 'Denis', '1988-05-27', 2, 'GHANA'),
(528, 'Vanaken', 'Hans', '1992-08-24', 3, 'BELGIQUE'),
(529, 'Vermeeren', 'Arthur', '2005-02-07', 3, 'BELGIQUE'),
(530, 'Vetlesen', 'Hugo', '2000-02-29', 3, 'NORVÈGE'),
(531, 'Onyedika', 'Raphael', '2001-04-19', 3, 'NIGÉRIA'),
(532, 'Zinckernagel', 'Philip', '1994-11-16', 4, 'DANEMARK'),
(533, 'Skov Olsen', 'Andreas', '1999-12-29', 4, 'DANEMARK'),
(534, 'Thiago', 'Igor', '2001-06-26', 4, 'BRÉSIL'),
(535, 'Nusa', 'Antonio', '2005-04-17', 4, 'NORVÈGE'),
(536, 'Jutglà', 'Ferran', '1999-02-01', 4, 'ESPAGNE'),
(537, 'Balanta', 'Éder', '1993-02-28', 3, 'COLOMBIE'),
(538, 'Boyata', 'Dedryck', '1990-11-28', 2, 'BELGIQUE'),
(539, 'Talbi', 'Mohamed', '2004-03-15', 3, 'MAROC'),
(540, 'Yaremchuk', 'Roman', '1995-11-27', 4, 'UKRAINE'),

-- ÉCOSSE (Celtic) - Joueurs 541 à 560
(541, 'Hart', 'Joe', '1987-04-19', 1, 'ANGLETERRE'),
(542, 'Bain', 'Scott', '1991-11-22', 1, 'ÉCOSSE'),
(543, 'Taylor', 'Greg', '1997-11-05', 2, 'ÉCOSSE'),
(544, 'Carter-Vickers', 'Cameron', '1997-12-31', 2, 'ÉTATS-UNIS'),
(545, 'Johnston', 'Alistair', '1998-10-08', 2, 'CANADA'),
(546, 'Scales', 'Liam', '1998-08-08', 2, 'IRLANDE'),
(547, 'Starfelt', 'Carl', '1995-06-01', 2, 'SUÈDE'),
(548, 'McGregor', 'Callum', '1993-06-14', 3, 'ÉCOSSE'),
(549, 'Turnbull', 'David', '1999-07-10', 3, 'ÉCOSSE'),
(550, 'Hatate', 'Reo', '1997-10-23', 3, 'JAPON'),
(551, 'O''Riley', 'Matt', '2000-11-21', 3, 'DANEMARK'),
(552, 'Maeda', 'Daizen', '1997-10-20', 4, 'JAPON'),
(553, 'Furuhashi', 'Kyogo', '1995-01-20', 4, 'JAPON'),
(554, 'Abada', 'Liel', '2001-10-03', 4, 'ISRAËL'),
(555, 'Yang', 'Hyun-jun', '2002-05-25', 4, 'CORÉE DU SUD'),
(556, 'Bernabei', 'Alexandro', '2000-09-26', 2, 'ARGENTINE'),
(557, 'Ralston', 'Anthony', '1998-11-16', 2, 'ÉCOSSE'),
(558, 'Miyoshi', 'Koji', '1997-03-16', 4, 'JAPON'),
(559, 'Haksabanovic', 'Sead', '1999-05-04', 4, 'MONTÉNÉGRO'),
(560, 'Holm', 'Odin', '2003-01-18', 3, 'NORVÈGE'),

-- ÉCOSSE (Rangers) - Joueurs 561 à 580
(561, 'Butland', 'Jack', '1993-03-10', 1, 'ANGLETERRE'),
(562, 'Raskin', 'Nicolas', '2001-02-23', 3, 'BELGIQUE'),
(563, 'Tavernier', 'James', '1991-10-31', 2, 'ANGLETERRE'),
(564, 'Goldson', 'Connor', '1992-12-18', 2, 'ANGLETERRE'),
(565, 'Souttar', 'John', '1996-09-25', 2, 'ÉCOSSE'),
(566, 'Barisic', 'Borna', '1992-11-05', 2, 'CROATIE'),
(567, 'Balogun', 'Leon', '1988-06-28', 2, 'NIGÉRIA'),
(568, 'Cantwell', 'Todd', '1998-02-27', 3, 'ANGLETERRE'),
(569, 'Lundstram', 'John', '1994-02-18', 3, 'ANGLETERRE'),
(570, 'Jack', 'Ryan', '1990-02-27', 3, 'ÉCOSSE'),
(571, 'Cifuentes', 'José', '1999-03-15', 3, 'ÉQUATEUR'),
(572, 'Dessers', 'Cyriel', '1994-12-08', 4, 'NIGÉRIA'),
(573, 'Sima', 'Abdallah', '2001-06-17', 4, 'SÉNÉGAL'),
(574, 'Danilo', 'Pereira', '1999-04-10', 4, 'BRÉSIL'),
(575, 'Wright', 'Scott', '1997-08-08', 4, 'ÉCOSSE'),
(576, 'Lammers', 'Sam', '1997-04-30', 4, 'PAYS-BAS'),
(577, 'Davies', 'Ben', '1995-08-11', 2, 'ANGLETERRE'),
(578, 'Lawrence', 'Tom', '1994-01-13', 3, 'PAYS DE GALLES'),
(579, 'McCrorie', 'Robby', '1998-03-18', 1, 'ÉCOSSE'),
(580, 'Sterling', 'Dujon', '1999-10-24', 2, 'ANGLETERRE'),

-- SUISSE (FC Bâle) - Joueurs 581 à 600
(581, 'Hitz', 'Marwin', '1987-09-18', 1, 'SUISSE'),
(582, 'Salvi', 'Mirko', '1994-02-14', 1, 'SUISSE'),
(583, 'Frei', 'Fabian', '1989-01-08', 2, 'SUISSE'),
(584, 'Lang', 'Michael', '1991-02-08', 2, 'SUISSE'),
(585, 'Vogel', 'Leon', '2000-02-09', 2, 'SUISSE'),
(586, 'Adjetey', 'Jonas', '2003-09-08', 2, 'SUISSE'),
(587, 'López', 'Sergio', '1999-04-28', 2, 'ESPAGNE'),
(588, 'Xhaka', 'Taulant', '1991-03-28', 3, 'ALBANIE'),
(589, 'Diouf', 'Andy', '2002-05-18', 3, 'SUISSE'),
(590, 'Kade', 'Anton', '2004-01-17', 3, 'ALLEMAGNE'),
(591, 'Amdouni', 'Zeki', '2000-12-04', 4, 'SUISSE'),
(592, 'Dubasin', 'Théo', '2000-07-14', 4, 'FRANCE'),
(593, 'Barry', 'Thierno', '2000-01-21', 4, 'FRANCE'),
(594, 'Obradovic', 'Mihailo', '2002-08-01', 4, 'SERBIE'),
(595, 'Hunzikar', 'Noel', '2003-09-20', 4, 'SUISSE'),
(596, 'Ndoye', 'Dan', '2000-10-25', 4, 'SUISSE'),
(597, 'Malone', 'Yannick', '2003-03-23', 3, 'SUISSE'),
(598, 'Krasniqi', 'Arton', '2004-02-10', 3, 'SUISSE'),
(599, 'Comas', 'Arnau', '2000-04-11', 2, 'ESPAGNE'),
(600, 'Tushi', 'Elmin', '2003-08-14', 2, 'SUISSE'),
-- AUTRICHE (Red Bull Salzbourg) - Joueurs 601 à 620
(601, 'Schlager', 'Alexander', '1996-02-01', 1, 'AUTRICHE'),
(602, 'Köhn', 'Philipp', '1998-04-02', 1, 'SUISSE'),
(603, 'Solet', 'Oumar', '2000-02-07', 2, 'FRANCE'),
(604, 'Dedıć', 'Amar', '2002-08-14', 2, 'BOSNIE-HERZÉGOVINE'),
(605, 'Pavlovic', 'Strahinja', '2001-05-24', 2, 'SERBIE'),
(606, 'Terzić', 'Aleksa', '1999-05-17', 2, 'SERBIE'),
(607, 'Morgalla', 'Leandro', '2003-09-13', 2, 'ALLEMAGNE'),
(608, 'Gourna-Douath', 'Lucas', '2003-08-05', 3, 'FRANCE'),
(609, 'Gloukh', 'Oscar', '2004-04-01', 3, 'ISRAËL'),
(610, 'Kjærgaard', 'Maurits', '2003-06-26', 3, 'DANEMARK'),
(611, 'Sučić', 'Luka', '2002-09-08', 3, 'CROATIE'),
(612, 'Forson', 'Amankwah', '2002-12-19', 4, 'GHANA'),
(613, 'Simić', 'Roko', '2003-09-10', 4, 'CROATIE'),
(614, 'Konate', 'Karim', '2004-03-06', 4, 'MAROC'),
(615, 'Ratkov', 'Petar', '2003-08-14', 4, 'SERBIE'),
(616, 'Nene', 'Nene', '2003-06-15', 4, 'BRÉSIL'),
(617, 'Capaldo', 'Nicolás', '1998-09-14', 3, 'ARGENTINE'),
(618, 'Piatkowski', 'Kamil', '2000-06-21', 2, 'POLOGNE'),
(619, 'Baidoo', 'Sami', '2004-10-18', 3, 'GHANA'),
(620, 'Wallner', 'Lukas', '2002-04-28', 2, 'AUTRICHE');
SET IDENTITY_INSERT CHAMPIONS_LIGUE.JOUEURS OFF;
GO

/* EQUIPES */
-- Adaptation IDENTITY_INSERT car vous avez spécifié equipe_id manuellement
SET IDENTITY_INSERT CHAMPIONS_LIGUE.EQUIPES ON;
INSERT INTO CHAMPIONS_LIGUE.EQUIPES (equipe_id, nomEquipe, abreviation, stade_id) VALUES
(1, 'Paris Saint-Germain', 'PSG', 1), (2, 'Olympique de Marseille', 'OM', 2), (3, 'RC Lens', 'RCL', 3), 
(4, 'Real Madrid CF', 'RMA', 4), (5, 'FC Barcelone', 'FCB', 5), (6, 'Wydad AC', 'WAC', 6), 
(7, 'Raja CA', 'RCA', 6), (8, 'Manchester United', 'MUN', 7), (9, 'Manchester City', 'MCI', 8), 
(10, 'Liverpool FC', 'LIV', 9), (11, 'Bayern Munich', 'BAY', 10), (12, 'Borussia Dortmund', 'BVB', 11), 
(13, 'Ajax Amsterdam', 'AJAX', 12), (14, 'PSV Eindhoven', 'PSV', 13), (15, 'AC Milan', 'ACM', 14), 
(16, 'Inter Milan', 'INT', 14), (17, 'Juventus FC', 'JUV', 15), (18, 'SSC Napoli', 'NAP', 16), 
(19, 'SL Benfica', 'SLB', 17), (20, 'FC Porto', 'FCP', 18), (21, 'Panathinaikos FC', 'PAO', 19),
(22, 'Shakhtar Donetsk', 'SDK', 22), (23, 'Dynamo Kiev', 'DYN', 23), (24, 'RSC Anderlecht', 'AND', 24),
(25, 'Club Brugge KV', 'BRU', 25), (26, 'Celtic FC', 'CEL', 26), (27, 'Rangers FC', 'RAN', 27),
(28, 'FC Bâle', 'BAS', 28), (29, 'Galatasaray SK', 'GAL', 20), (30, 'Fenerbahçe SK', 'FEN', 21), 
(31, 'Red Bull Salzbourg', 'RBS', 29);
SET IDENTITY_INSERT CHAMPIONS_LIGUE.EQUIPES OFF;
GO

/* JOURNEES */
IF OBJECT_ID('tempdb..#JourneesGenerales') IS NOT NULL DROP TABLE #JourneesGenerales;
CREATE TABLE #JourneesGenerales (saison_id INT, numero_journee INT, date_calculee DATE);
DECLARE @saison_id INT, @annee_debut INT;
DECLARE SaisonCursor CURSOR FOR SELECT saison_id, annee_debut FROM CHAMPIONS_LIGUE.SAISONS;
OPEN SaisonCursor; FETCH NEXT FROM SaisonCursor INTO @saison_id, @annee_debut;
WHILE @@FETCH_STATUS = 0 BEGIN
    DECLARE @i INT = 1; WHILE @i <= 30 BEGIN
        INSERT INTO #JourneesGenerales VALUES (@saison_id, @i, DATEADD(week, @i - 1, DATEFROMPARTS(@annee_debut, 8, 1)));
        SET @i = @i + 1;
    END
    FETCH NEXT FROM SaisonCursor INTO @saison_id, @annee_debut;
END
CLOSE SaisonCursor; DEALLOCATE SaisonCursor;
INSERT INTO CHAMPIONS_LIGUE.JOURNEES (saison_id, numero_journee, date_limite)
SELECT saison_id, numero_journee, date_calculee FROM #JourneesGenerales;
GO


-- ==========================================================
-- INITIALISATION RÉALISTE DE LA SAISON 1 (TON MAPPING)
-- ==========================================================
DECLARE @SaisonID INT = 1;
DECLARE @DateDebutSaison1 DATE = (SELECT DATEFROMPARTS(annee_debut, 7, 1) FROM CHAMPIONS_LIGUE.SAISONS WHERE saison_id = 1);
DECLARE @NbEquipes INT = 16;

-- A. Inscription des 31 équipes pour la Saison 1
INSERT INTO CHAMPIONS_LIGUE.SAISON_EQUIPES (saison_id, equipe_id)
SELECT @SaisonID, equipe_id FROM CHAMPIONS_LIGUE.EQUIPES;

-- B. Placement des 620 joueurs selon TES tranches d'ID (PlayerTeamMapping)
WITH PlayerTeamMapping AS (
    SELECT joueur_id, 'PSG' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 1 AND 20 UNION ALL
    SELECT joueur_id, 'OM'  AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 21 AND 40 UNION ALL
    SELECT joueur_id, 'RCL' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 41 AND 60 UNION ALL
    SELECT joueur_id, 'RMA' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 61 AND 80 UNION ALL
    SELECT joueur_id, 'FCB' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 81 AND 100 UNION ALL
    SELECT joueur_id, 'WAC' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 101 AND 120 UNION ALL
    SELECT joueur_id, 'RCA' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 121 AND 140 UNION ALL
    SELECT joueur_id, 'MUN' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 141 AND 160 UNION ALL
    SELECT joueur_id, 'MCI' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 161 AND 180 UNION ALL
    SELECT joueur_id, 'LIV' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 181 AND 200 UNION ALL
    SELECT joueur_id, 'BAY' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 201 AND 220 UNION ALL
    SELECT joueur_id, 'BVB' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 221 AND 240 UNION ALL
    SELECT joueur_id, 'AJAX' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 241 AND 260 UNION ALL
    SELECT joueur_id, 'PSV' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 261 AND 280 UNION ALL
    SELECT joueur_id, 'ACM' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 281 AND 300 UNION ALL
    SELECT joueur_id, 'INT' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 301 AND 320 UNION ALL
    SELECT joueur_id, 'JUV' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 321 AND 340 UNION ALL
    SELECT joueur_id, 'NAP' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 341 AND 360 UNION ALL
    SELECT joueur_id, 'SLB' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 361 AND 380 UNION ALL
    SELECT joueur_id, 'FCP' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 381 AND 400 UNION ALL
    SELECT joueur_id, 'PAO' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 401 AND 420 UNION ALL
    SELECT joueur_id, 'GAL' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 421 AND 440 UNION ALL
    SELECT joueur_id, 'FEN' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 441 AND 460 UNION ALL
    SELECT joueur_id, 'SDK' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 461 AND 480 UNION ALL
    SELECT joueur_id, 'DYN' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 481 AND 500 UNION ALL
    SELECT joueur_id, 'AND' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 501 AND 520 UNION ALL
    SELECT joueur_id, 'BRU' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 521 AND 540 UNION ALL
    SELECT joueur_id, 'CEL' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 541 AND 560 UNION ALL
    SELECT joueur_id, 'RAN' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 561 AND 580 UNION ALL
    SELECT joueur_id, 'BAS' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 581 AND 600 UNION ALL
    SELECT joueur_id, 'RBS' AS abr FROM CHAMPIONS_LIGUE.JOUEURS WHERE joueur_id BETWEEN 601 AND 620
)
INSERT INTO CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON (saison_id, joueur_id, equipe_id, date_arrivee)
SELECT @SaisonID, ptm.joueur_id, eq.equipe_id, @DateDebutSaison1
FROM PlayerTeamMapping ptm 
JOIN CHAMPIONS_LIGUE.EQUIPES eq ON ptm.abr = eq.abreviation;

-- C. Placement des 31 entraîneurs
INSERT INTO CHAMPIONS_LIGUE.ENTRAINEURS_EQUIPE_SAISON (saison_id, entraineur_id, equipe_id, date_arrivee)
SELECT 1, e.entraineur_id, eq.equipe_id, @DateDebutSaison1
FROM (SELECT entraineur_id, ROW_NUMBER() OVER (ORDER BY NEWID()) as rn FROM CHAMPIONS_LIGUE.ENTRAINEURS) e
JOIN (SELECT equipe_id, ROW_NUMBER() OVER (ORDER BY NEWID()) as rn FROM CHAMPIONS_LIGUE.EQUIPES) eq ON e.rn = eq.rn;

-- 1. Nettoyage pour la saison en cours
DELETE FROM CHAMPIONS_LIGUE.SAISON_EQUIPES WHERE saison_id = @SaisonID;

-- 2. Sélection des 16 élus pour la saison
INSERT INTO CHAMPIONS_LIGUE.SAISON_EQUIPES (saison_id, equipe_id)
SELECT TOP(@NbEquipes) @SaisonID, equipe_id 
FROM CHAMPIONS_LIGUE.EQUIPES 
ORDER BY equipe_id ASC;
GO

-- ==========================================================
-- TABLE MATCHS (Génération du calendrier et scores)
-- ==========================================================
DECLARE @SaisonID INT = 1; 
DECLARE @NbRounds INT = 15; 
DECLARE @IntervalleJournee INT = 7; 
DECLARE @DateBaseJournee DATE = (SELECT DATEFROMPARTS(annee_debut, 7, 1) FROM CHAMPIONS_LIGUE.SAISONS WHERE saison_id = @SaisonID);

DELETE FROM CHAMPIONS_LIGUE.MATCHS WHERE saison_id = @SaisonID;
DBCC CHECKIDENT ('CHAMPIONS_LIGUE.MATCHS', RESEED, 0);

IF OBJECT_ID('tempdb..#Participants') IS NOT NULL DROP TABLE #Participants;
CREATE TABLE #Participants (EquipeID INT, Rownum INT PRIMARY KEY);

INSERT INTO #Participants (EquipeID, Rownum)
SELECT SE.equipe_id, ROW_NUMBER() OVER (ORDER BY SE.equipe_id)
FROM CHAMPIONS_LIGUE.SAISON_EQUIPES SE
WHERE SE.saison_id = @SaisonID;

WITH StaticScheduleAller (numero_journee, Rownum_Domicile, Rownum_Exterieur) AS (
    SELECT 1, 1, 16 UNION ALL SELECT 1, 2, 15 UNION ALL SELECT 1, 3, 14 UNION ALL SELECT 1, 4, 13 UNION ALL SELECT 1, 5, 12 UNION ALL SELECT 1, 6, 11 UNION ALL SELECT 1, 7, 10 UNION ALL SELECT 1, 8, 9 UNION ALL
    SELECT 2, 1, 15 UNION ALL SELECT 2, 16, 14 UNION ALL SELECT 2, 2, 13 UNION ALL SELECT 2, 3, 12 UNION ALL SELECT 2, 4, 11 UNION ALL SELECT 2, 5, 10 UNION ALL SELECT 2, 6, 9 UNION ALL SELECT 2, 7, 8 UNION ALL
    SELECT 3, 1, 14 UNION ALL SELECT 3, 15, 13 UNION ALL SELECT 3, 16, 12 UNION ALL SELECT 3, 2, 11 UNION ALL SELECT 3, 3, 10 UNION ALL SELECT 3, 4, 9 UNION ALL SELECT 3, 5, 8 UNION ALL SELECT 3, 6, 7 UNION ALL
    SELECT 4, 1, 13 UNION ALL SELECT 4, 14, 12 UNION ALL SELECT 4, 15, 11 UNION ALL SELECT 4, 16, 10 UNION ALL SELECT 4, 2, 9 UNION ALL SELECT 4, 3, 8 UNION ALL SELECT 4, 4, 7 UNION ALL SELECT 4, 5, 6 UNION ALL
    SELECT 5, 1, 12 UNION ALL SELECT 5, 13, 11 UNION ALL SELECT 5, 14, 10 UNION ALL SELECT 5, 15, 9 UNION ALL SELECT 5, 16, 8 UNION ALL SELECT 5, 2, 7 UNION ALL SELECT 5, 3, 6 UNION ALL SELECT 5, 4, 5 UNION ALL
    SELECT 6, 1, 11 UNION ALL SELECT 6, 12, 10 UNION ALL SELECT 6, 13, 9 UNION ALL SELECT 6, 14, 8 UNION ALL SELECT 6, 15, 7 UNION ALL SELECT 6, 16, 6 UNION ALL SELECT 6, 2, 5 UNION ALL SELECT 6, 3, 4 UNION ALL
    SELECT 7, 1, 10 UNION ALL SELECT 7, 11, 9 UNION ALL SELECT 7, 12, 8 UNION ALL SELECT 7, 13, 7 UNION ALL SELECT 7, 14, 6 UNION ALL SELECT 7, 15, 5 UNION ALL SELECT 7, 16, 4 UNION ALL SELECT 7, 2, 3 UNION ALL
    SELECT 8, 1, 9 UNION ALL SELECT 8, 10, 8 UNION ALL SELECT 8, 11, 7 UNION ALL SELECT 8, 12, 6 UNION ALL SELECT 8, 13, 5 UNION ALL SELECT 8, 14, 4 UNION ALL SELECT 8, 15, 3 UNION ALL SELECT 8, 16, 2 UNION ALL
    SELECT 9, 1, 8 UNION ALL SELECT 9, 9, 7 UNION ALL SELECT 9, 10, 6 UNION ALL SELECT 9, 11, 5 UNION ALL SELECT 9, 12, 4 UNION ALL SELECT 9, 13, 3 UNION ALL SELECT 9, 14, 2 UNION ALL SELECT 9, 15, 16 UNION ALL
    SELECT 10, 1, 7 UNION ALL SELECT 10, 8, 6 UNION ALL SELECT 10, 9, 5 UNION ALL SELECT 10, 10, 4 UNION ALL SELECT 10, 11, 3 UNION ALL SELECT 10, 12, 2 UNION ALL SELECT 10, 13, 16 UNION ALL SELECT 10, 14, 15 UNION ALL
    SELECT 11, 1, 6 UNION ALL SELECT 11, 7, 5 UNION ALL SELECT 11, 8, 4 UNION ALL SELECT 11, 9, 3 UNION ALL SELECT 11, 10, 2 UNION ALL SELECT 11, 11, 16 UNION ALL SELECT 11, 12, 15 UNION ALL SELECT 11, 13, 14 UNION ALL
    SELECT 12, 1, 5 UNION ALL SELECT 12, 6, 4 UNION ALL SELECT 12, 7, 3 UNION ALL SELECT 12, 8, 2 UNION ALL SELECT 12, 9, 16 UNION ALL SELECT 12, 10, 15 UNION ALL SELECT 12, 11, 14 UNION ALL SELECT 12, 12, 13 UNION ALL
    SELECT 13, 1, 4 UNION ALL SELECT 13, 5, 3 UNION ALL SELECT 13, 6, 2 UNION ALL SELECT 13, 7, 16 UNION ALL SELECT 13, 8, 15 UNION ALL SELECT 13, 9, 14 UNION ALL SELECT 13, 10, 13 UNION ALL SELECT 13, 11, 12 UNION ALL
    SELECT 14, 1, 3 UNION ALL SELECT 14, 4, 2 UNION ALL SELECT 14, 5, 16 UNION ALL SELECT 14, 6, 15 UNION ALL SELECT 14, 7, 14 UNION ALL SELECT 14, 8, 13 UNION ALL SELECT 14, 9, 12 UNION ALL SELECT 14, 10, 11 UNION ALL
    SELECT 15, 1, 2 UNION ALL SELECT 15, 3, 16 UNION ALL SELECT 15, 4, 15 UNION ALL SELECT 15, 5, 14 UNION ALL SELECT 15, 6, 13 UNION ALL SELECT 15, 7, 12 UNION ALL SELECT 15, 8, 11 UNION ALL SELECT 15, 9, 10
),
FullSchedule AS (
    SELECT SSA.numero_journee, P_Dom.EquipeID AS dom_id, P_Ext.EquipeID AS ext_id FROM StaticScheduleAller SSA
    JOIN #Participants P_Dom ON SSA.Rownum_Domicile = P_Dom.Rownum
    JOIN #Participants P_Ext ON SSA.Rownum_Exterieur = P_Ext.Rownum
    UNION ALL
    SELECT SSA.numero_journee + @NbRounds, P_Ext.EquipeID, P_Dom.EquipeID FROM StaticScheduleAller SSA
    JOIN #Participants P_Dom ON SSA.Rownum_Domicile = P_Dom.Rownum
    JOIN #Participants P_Ext ON SSA.Rownum_Exterieur = P_Ext.Rownum
)
INSERT INTO CHAMPIONS_LIGUE.MATCHS (saison_id, numero_journee, equipe_domicile_id, equipe_exterieur_id, stade_id, date_match, buts_domicile, buts_exterieur)
SELECT @SaisonID, FS.numero_journee, FS.dom_id, FS.ext_id, EQ_DOM.stade_id, 
       DATEADD(day, (FS.numero_journee - 1) * @IntervalleJournee, @DateBaseJournee),
       CAST(RAND(CHECKSUM(NEWID())) * 6 AS INT), CAST(RAND(CHECKSUM(NEWID())) * 6 AS INT)
FROM FullSchedule FS
JOIN CHAMPIONS_LIGUE.EQUIPES EQ_DOM ON FS.dom_id = EQ_DOM.equipe_id;

-- ==========================================================
-- TABLE BUTS (Détails par buteur)
-- ==========================================================
-- 1. Nettoyage
DELETE FROM CHAMPIONS_LIGUE.BUTS WHERE match_id IN (SELECT match_id FROM CHAMPIONS_LIGUE.MATCHS WHERE saison_id = 1);

-- 2. Structure temporaire
IF OBJECT_ID('tempdb..#TempButs') IS NOT NULL DROP TABLE #TempButs;
CREATE TABLE #TempButs (match_id INT, equipe_but_id INT, equipe_adverse_id INT, type_nom VARCHAR(50));

-- 3. Génération avec Nums élargi à 15
WITH Nums AS (
    SELECT n FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15)) AS T(n)
)
INSERT INTO #TempButs (match_id, equipe_but_id, equipe_adverse_id, type_nom)
SELECT M.match_id, M.equipe_domicile_id, M.equipe_exterieur_id, 
       CASE WHEN RAND(CHECKSUM(NEWID())) < 0.01 THEN 'CSC' 
            WHEN RAND(CHECKSUM(NEWID())) < 0.05 THEN 'Penalty' 
            ELSE 'Pied' END
FROM CHAMPIONS_LIGUE.MATCHS M CROSS JOIN Nums N 
WHERE M.saison_id = 1 AND N.n <= M.buts_domicile
UNION ALL
SELECT M.match_id, M.equipe_exterieur_id, M.equipe_domicile_id,
       CASE WHEN RAND(CHECKSUM(NEWID())) < 0.01 THEN 'CSC' 
            WHEN RAND(CHECKSUM(NEWID())) < 0.05 THEN 'Penalty' 
            ELSE 'Pied' END
FROM CHAMPIONS_LIGUE.MATCHS M CROSS JOIN Nums N 
WHERE M.saison_id = 1 AND N.n <= M.buts_exterieur;

-- 4. Insertion finale
INSERT INTO CHAMPIONS_LIGUE.BUTS (match_id, joueur_id, equipe_but_id, minute_but, type_but_id)
SELECT 
    TB.match_id,
    COALESCE(
        (SELECT TOP 1 J.joueur_id FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON J 
         WHERE J.saison_id = 1 AND J.equipe_id = (CASE WHEN TB.type_nom = 'CSC' THEN TB.equipe_adverse_id ELSE TB.equipe_but_id END)
         ORDER BY NEWID()), 
        (SELECT TOP 1 joueur_id FROM CHAMPIONS_LIGUE.JOUEURS_EQUIPE_SAISON WHERE saison_id = 1)
    ),
    TB.equipe_but_id,
    CAST(RAND(CHECKSUM(NEWID())) * 90 AS INT) + 1,
    TBR.type_but_id
FROM #TempButs TB
JOIN CHAMPIONS_LIGUE.TYPES_BUTS_REFERENCE TBR ON TB.type_nom = TBR.nom_type_but;
DROP TABLE #TempButs;