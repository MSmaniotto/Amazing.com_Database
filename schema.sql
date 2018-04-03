DROP TABLE IF EXISTS Carta_di_Credito;
DROP TABLE IF EXISTS Istanza_Oggetto;
DROP TABLE IF EXISTS Corriere;
DROP TABLE IF EXISTS E_Shop;
DROP TABLE IF EXISTS Fornitore;
DROP TABLE IF EXISTS Magazzino;
DROP TABLE IF EXISTS Oggetto;
DROP TABLE IF EXISTS Ordine;
DROP TABLE IF EXISTS Spedizione;
DROP TABLE IF EXISTS Selezione;
DROP TABLE IF EXISTS Transazione;
DROP TABLE IF EXISTS Utente;

CREATE TABLE Utente 
(
Email                       varchar (191) not null UNIQUE,
Nome                        varchar (191),
Cognome                     varchar (191),
Spesa_Mensile_Complessiva   int (10),
PRIMARY KEY(Email)
);

CREATE TABLE Fornitore
(
Nome                        varchar(191) not null UNIQUE,
Email                       varchar(191) UNIQUE,
Indirizzo                   varchar(191),
Complessivo_rifornimenti    decimal(10, 2),
PRIMARY KEY(Nome)
);

CREATE TABLE Carta_di_Credito
(
Circuito                    varchar (191) not null,
Numero                      varchar (25) not null,
Scadenza                    date not null,
Stato                       boolean,
Proprietario                varchar (191) not null,
PRIMARY KEY(Circuito, Numero, Scadenza)
);

CREATE TABLE Transazione
(
ID_Ordine                   int REFERENCES Ordine(ID),
Mail_Utente                 varchar (191) REFERENCES Utente(Email),
ID_Transazione              int not null UNIQUE AUTO_INCREMENT,
Iva                         decimal (2, 2),
Importo_Netto               decimal (10, 2),
Beneficiario                varchar (191),
Mittente                    varchar (191),
Sconto                      decimal (2, 2),
Numero_carta                varchar (25) REFERENCES Carta_di_Credito(Numero),
Circuito_carta              varchar (191) REFERENCES Carta_di_Credito(Circuito),
Stato                       boolean,
PRIMARY KEY(ID_Transazione)
);

CREATE TABLE Spedizione
(
ID_Ordine                   int AUTO_INCREMENT REFERENCES Ordine(ID),
Nome_Corriere               varchar (191) REFERENCES Corriere(Nome),
Numero                      int (2), #utile quando ho un ordine con oggetti di dimensioni eccessive da spedire separatamente
PRIMARY KEY(ID_Ordine, Nome_Corriere, Numero)
);

CREATE TABLE Ordine
(
ID                          int not null UNIQUE AUTO_INCREMENT,
DataOra                     datetime,
URL_Sito                    varchar (191) REFERENCES E_Shop(URL),
Email_Cliente               varchar (191) REFERENCES Utente(Email),
Importo                     decimal (10, 2),
Indirizzo_di_Spedizione     varchar (191) not null,
Status                      varchar (191),
PRIMARY KEY(ID)
);

CREATE TABLE E_Shop
(
URL                         varchar (191) not null UNIQUE,
Indirizzo                   varchar (191) not null,
Recapito_Assistenza         varchar (191) not null,
Somma_Stipendi_Dipendenti   decimal (16, 2),
Costo_Gestione_Mensile      decimal (16, 2),
PRIMARY KEY(URL)
);

CREATE TABLE Oggetto
(
Codice_a_Barre              varchar (15) not null UNIQUE,
Nome                        varchar (191) not null,
Marca                       varchar (191) REFERENCES Fornitore(Nome),
Prezzo                      decimal (10, 2),
Peso                        decimal (8, 2),
Colore                      varchar (191),
Tipologia                   varchar (191),
PRIMARY KEY(Codice_a_Barre)
);

CREATE TABLE Selezione
(
ID_Oggetto                  varchar (15) REFERENCES Oggetto(Codice_a_Barre),
ID_Ordine                   int (10) REFERENCES Ordine(ID),
Quantita_selezionata        int (10),
Magazzino		            varchar (2) REFERENCES Magazzino(ID),
PRIMARY KEY(ID_Oggetto, ID_Ordine, Magazzino)
);	

CREATE TABLE Corriere
(
Nome                        varchar (191) not null UNIQUE,
Indirizzo_sede              varchar (191),
Recapito_Telefonico         int (12),
PRIMARY KEY(Nome)
);

CREATE TABLE Istanza_Oggetto
(
Nazionalita                 varchar (191) REFERENCES Magazzino(Nazionalita),
Codice_a_Barre              varchar (15) REFERENCES Oggetto(Codice_a_Barre),
ID_Magazzino                int (3) REFERENCES Magazzino(ID),
Quantita                    int (100),
Riserva                     int (5),
PRIMARY KEY(Codice_a_Barre, ID_Magazzino)
);


CREATE TABLE Magazzino
(
ID                          int (3) ,
Nazionalita                 varchar (191),
Indirizzo                   varchar (191),
PRIMARY KEY(ID, Nazionalita)
);


INSERT INTO Utente
VALUES  
( 'mario.rossi@gmail.com', 'Mario', 'Rossi', 0 ),
( 'enrico.bianchi@gmail.com', 'Enrico', 'Bianchi', 0 ),
( 'filippo.neri@yahoo.com', 'Filippo', 'Neri', 0 ),
( 'alessandro.canesso@gmail.com', 'Alessandro', 'Canesso', 0 ),
( 'michaelbrown@hotmail.com', 'Michael', 'Brown', 0 ),
( 'pedro.sanchez@gmail.com', 'Pedro', 'Sanchez', 0 ),
( 'peterstigliz@yahoo.de', 'Peter', 'Stigliz', 0 ),
( 'francoispinot@yahoo.fr', 'Francois', 'Pinot', 0 )
;

INSERT INTO Fornitore
VALUES	
( 'Samsung', 'supplier@samsung.com', 'London, UK', '' ),
( 'Apple', 'supplier@apple.com', '1 Infinite Loop, Cupertino, CA', '' ),
( 'LG', 'supplier@lginternational.com', '20, Ocean Avenue, London, UK', '' ),
( 'ASUS', 'supplierdivision@asus.com', '800 Corporate Way, Fremont, CA', ''),
( 'Adidas', 'supplies@adidas.com', 'Moselstrasse 22, Berlin, DE', ''),
( 'Cellular Line', 'supplies@cellularline.com', 'Via Pradel 8, Padova, IT', ''),
( 'Converse', 'supplies@converse.com', 'Via Laboratorio 10, Verona, IT', '')
;

INSERT INTO Carta_di_Credito
VALUES	( 'MasterCard', '5208928454728826', '2020-05-01', '1', 'Mario Rossi' ),
( 'MasterCard', '5349787753000000', '2015-03-01', '0', 'Mario Rossi' ),
('MasterCard', '5200595708846866', '2021-05-01', '1', 'Enrico Bianchi' ),
( 'MasterCard', '5369621279972944', '2019-08-01', '1', 'Erlich Bachman' ),
( 'Visa', '4485459285117382', '2014-03-01', '0', 'Peter Stigliz' ),
( 'Visa', '4485459285117382', '2019-02-01', '1', 'Peter Stigliz' ),
( 'Visa', '4916958336059955', '2022-02-01', '1', 'Enrico Bianchi' ),
( 'Visa', '6986861098354190', '2019-02-01', '1', 'Filippo Neri' ),
( 'MasterCard', '5616523532429286', '2020-02-01', '1', 'Alessandro Canesso'),
( 'MasterCard', '6478246218618631', '2018-02-01', '1', 'Francois Pinot' ),
( 'Visa', '3146274394239412', '2019-02-01', '1', 'Michael Brown' ),
( 'Visa', '4916958336059955', '2020-02-01', '1', 'Pedro Sanchez' )
;

INSERT INTO Spedizione
VALUES  ( 1, 'Bartolini', 1 ),
( 2, 'Bartolini', 1 ),
( 3, 'FedEx', 1 ),
( 3, 'FedEx', 2 ),
( 4, 'Mail Boxes', 1 ),
( 5, 'Bartolini', 1 ),
( 6, 'FedEx', 1 ),
( 7, 'Mail Boxes', 1 ),
( 8, 'Bartolini', 1 ),
( 9, 'FedEx', 1 ),
( 10, 'Mail Boxes', 1 ),
( 11, 'Bartolini', 1 )
;

INSERT INTO Ordine
VALUES  ( 1, "17-02-17 22:37" , 'www.amazing.it', 'mario.rossi@gmail.com', 125.00 , 'Via dei Fiori 43, Padova' , 'COMPLETATO' ),
( 2, "17-02-18 15:22" , 'www.amazing.it', 'mario.rossi@gmail.com', 744.98 , 'Piazza Garibaldi 54, Padova', 'COMPLETATO' ),
( 3, "17-02-19 05:34" , 'www.amazing.it', 'mario.rossi@gmail.com', 1904.99 , 'Piazza Garibaldi 54, Padova', 'IN CORSO' ),
( 4, "17-02-19 11:54" , 'www.amazing.es', 'pedro.sanchez@gmail.com', 5234.95 , 'Plaza de Libertad 23, Barcellona','COMPLETATO'),
( 5, "17-02-20 13:37 ", 'www.amazing.it', 'enrico.bianchi@gmail.com', 174.95 , 'Viale Ducale 12, Milano', 'COMPLETATO'),
( 6, "17-02-22 17:12 ", 'www.amazing.fr', 'filippo.neri@yahoo.com', 1469.98 , 'Piazza Duomo 18, Firenze', 'COMPLETATO'),        
( 7, "17-02-22 20:19" , 'www.amazing.fr', 'filippo.neri@yahoo.com', 185.00 , 'Piazza Duomo 18, Firenze', 'COMPLETATO'),
( 8, "17-02-23 06:32" , 'www.amazing.it', 'mario.rossi@gmail.com', 499.95 , 'Piazza Garibaldi 54, Padova', 'COMPLETATO' ),		
( 9, "17-02-23 06:54" , 'www.amazing.it', 'mario.rossi@gmail.com', 134.87 , 'Piazza Garibaldi 54, Padova', 'COMPLETATO' ),
( 10, "17-02-25 15:37 ", 'www.amazing.it', 'enrico.rossi@gmail.com', 804.97 , 'Piazza Garibaldi 54, Padova', 'COMPLETATO' ),
( 11, "17-02-28 12:23", 'www.amazing.de', 'peterstigliz@yahoo.de', 744.99 , 'Fahrrad Strasse 23, Berlin', 'COMPLETATO'),
( 12, "17-03-1 10:22", 'www.amazing.uk', 'michaelbrown@hotmail.com', 74.93 , 'Liverpool Road 22, Liverpool', 'COMPLETATO'),
( 13, "17-03-1 11:25", 'www.amazing.uk', 'michaelbrown@hotmail.com', 1904.99 , 'Wales Road 22, London', 'COMPLETATO'),
( 14, "17-03-2 22:23", 'www.amazing.fr', 'francoispinot@yahoo.fr',  874.97, 'Rue de Lyon 12, Marsille', 'COMPLETATO'),
( 15, "17-03-3 03:34", 'www.amazing.it', 'alessandro.canesso@gmail.com', 104.99 ,'Viale Roma 123, Padova', 'COMPLETATO')

INSERT INTO E_Shop	
VALUES  ( 'www.amazing.it', 'Via del Lavoro 23, Roma', '3409923432', '10345,34', '53234,54' ),
( 'www.amazing.es', 'Plaza Concordia 21, Madrid', '3332345673', '8345,54', '45231,12' ),
( 'www.amazing.uk', 'Cardiff Road 54, London', '3325453535', '15234,12', '73233,57'),
( 'www.amazing.de', 'Arbeit Strasse 1, Berlin', '3674355452', '21345,23', '80234,34' ),
( 'www.amazing.fr', 'Rue Eiffel 32, Paris', '3432543524', '12453,43', '24234,22' )
;

INSERT INTO Oggetto
VALUES  ( '1', 'IPhone 7', 'Apple', '729,99', 0.232, 'Nero', 'Smartphone' ),
( '2', 'IPhone 7', 'Apple', '734,99', 0.232, 'Bianco', 'Smartphone' ),
( '3', 'Galaxy S7', 'Samsung', '739,99', 0.249, 'Bianco', 'Smartphone'),
( '4', 'Galaxy S7 Edge', 'Samsung', 779.99, '0,253', 'Bianco', 'Smartphone'),
( '5', 'ZenBook', 'ASUS', '1899,99', 1.154, 'Gold', 'Laptop' ),
( '6', 'MacBook Air', 'Apple', '1799,99', 1.114, 'Bianco', 'Laptop' ),
( '7', 'MacBook Pro', 'Apple', '2599,99', 1.253, 'Bianco', 'Laptop' ),
( '8', 'Originals', 'Adidas', '99,99', 1.543, 'Bianco', 'Scarpe'),
( '9', 'Stan Smith', 'Adidas', '59,99', 1.343, 'Bianco', 'Scarpe'),
( '10', 'All Star', 'Converse', '60,00', 0.960, 'Blu', 'Scarpe'),
( '11', 'All Star', 'Converse', '60,00', 0.960, 'Verdi', 'Scarpe'),
( '12', 'All Star', 'Converse', '60,00', 0.960, 'Gialle', 'Scarpe'),
( '13', 'Cover IPhone 7', 'Cellular Line', '9.99', 0.100, 'Bianco', 'Cover Smartphone'),
( '14', 'Cover IPhone 7', 'Cellular Line', '9.99', 0.100, 'Trasparente', 'Cover Smartphone'),
( '15', 'Cover IPhone 7', 'Cellular Line', '8.99', 0.100, 'Nero', 'Cover Smartphone'),
( '16', 'Cover Galaxy S7', 'Cellular Line', '7.99', 0.115, 'Bianco', 'Cover Smartphone'),
( '17', 'Cover Galaxy S7', 'Cellular Line', '9.99', 0.115, 'Nero', 'Cover Smartphone')
;

INSERT INTO Selezione
VALUES
( 10, 1, 2, 6 ),
( 1, 2, 1, 1 ),
( 13, 2, 1, 2 ),
( 5, 3, 1, 1 ),
( 7, 4, 2, 17 ),
( 13, 4, 3, 15 ),
( 11, 5, 2, 4 ),
( 13, 5, 1, 5 ),
( 14, 5, 4, 6 ),
( 1, 6, 1, 4 ),
( 2, 6, 1, 6 ),
( 11, 7, 1, 4 ),
( 11, 7, 2, 5 ),
( 8, 8, 5, 2 ),
( 13, 9, 13, 2 ),
( 4, 10, 1, 2 ),
( 17, 10, 2, 2 ),
( 3, 11, 1, 9),
( 13, 12, 2, 11 ),
( 13, 12, 5, 12 ),
( 5, 13, 1, 11 ),
( 1, 14, 1, 4 ),
( 13, 14, 2, 5 ),
( 12, 14, 2, 6 ),
( 8, 15, 1, 2 )
;

INSERT INTO Corriere
VALUES	('FedEx', '2491 Winchester Rd, Memphis, TN 38116, Stati Uniti', '19019228000' ),
('Bartolini', 'Piazza Diaz 7, Milano, 20123, Italia', '39051530365' ),
('Mail Boxes', ' Viale Lunigiana 35/37, Milano, 20125, Italia', '390267625777')
;

INSERT INTO Magazzino
VALUES
( '1', 'Italia', 'Via Trieste 5, Padova'),
( '2', 'Italia', 'Via Venezia 23, Roma' ),
( '3', 'Italia', 'Corso 25 Aprile 59, Bari' ),
( '4', 'Francia', 'Rue de la Fraternitè 120, Paris'),
( '5', 'Francia', 'Rue de la Prosperitè 88, Lyon' ),
( '6', 'Francia', 'Rue De Galle 12, Nantes' ),
( '7', 'Germania', 'Fahrrad Strasse 43, Munchen' ),
( '8', 'Germania', 'Bismarck Strasse 29, Berlin' ),
( '9', 'Germania', 'Hegel Strasse 10, Amburg' ),
( '10', 'Germania', 'Moselstrasse 23, Koln' ),
( '11', 'Germania', 'Schaafen Strasse 88, Stuttgard' ),
( '12', 'Regno Unito', 'Churchill Road 123, London' ),
( '13', 'Regno Unito', 'Canford Road 24, Liverpool' ),
( '14', 'Regno Unito', 'Queen Elizabeth Street41, Glasgow'),
( '15', 'Regno Unito', 'Duncue Street 65, Belfast' ),
( '16', 'Spagna', 'Calle Esmeralda 70, Madrid' ),
( '17', 'Spagna', 'Calle San Filiberto 65, Barcellona' )
;

INSERT INTO Istanza_Oggetto
VALUES 
       ('Italia','1', 1, 126,150),
       ('Italia','1', 2, 126,150),
       ('Italia','1', 3, 126,150),  
       ('Italia','2', 3, 210,100),
       ('Italia','4', 2,148,100),
       ('Italia','5', 1,237,50),
       ('Italia','8',2,211,100),
       ('Italia','12',1,196,100),
       ('Italia', '13',2,133,200),
       ('Italia','11',3,217,100),
       ('Italia','17',2,219,180),
       ('Italia','3',1,124,150),
       ('Italia','9',2,187,100),
       ('Italia','2',1,205,100),

       ('Francia','1',4,194,150),
       ('Francia','1',5,194,150),
       ('Francia','1',6,194,150),
       ('Francia','5',6,148,50),
       ('Francia','9',4,214,100),
       ('Francia','8',5,185,100),
       ('Francia','11',4,117,100),
       ('Francia','13',5,253,200),
       ('Francia','14',6,271,250),
       ('Francia','7',4,192,20),
       ('Francia','16',5,203,200),
       ('Francia','10',6,174,100),
       ('Francia','4',5,164,100),
       ('Francia','2',6,192,100),
       ('Francia','8',4,138,100),
       ('Francia','12',6,207,100),
       ('Francia','11',5,194,100),
       ('Francia','7',5,167,20),
       ('Francia','2',5, 213,100),

       ('Germania','3',7,127,150),
       ('Germania','1',9,153,150),
       ('Germania','1',7,153,150),
       ('Germania','1',8,153,150),
       ('Germania','4',7,241,100),
       ('Germania','3',9,225,150),
       ('Germania','8',7,169,100),
       ('Germania','6',10,198,50),
       ('Germania','15',8,122,200),
       ('Germania','11',9,174,100),
       ('Germania','13',7,259,200),
       ('Germania','16',10,265,200),
       ('Germania','8',8,172,100),
       ('Germania','7',7,165,20),
       ('Germania','12',7,137,100),
       ('Germania','10',8,164,100),
       ('Germania','1',10,111,150),
       ('Germania','4',8,185,100),
       ('Germania','9',7,162,100),
       ('Germania','15',10,249,200),
       ('Germania','17',9,257,180),
       ('Germania','16',8,229,200),
       ('Germania','12',9,131,100),
       ('Germania','14',7,238,250),
       ('Germania','8',9,165,100),
       ('Germania','6',8,119,50),
       ('Germania','13',8,207,200),
       ('Germania','7',10,146,20),
       ('Germania','5',7,187,50),

       ('Regno Unito','7',12,112,20),
       ('Regno Unito','1',11,137,150),
       ('Regno Unito','1',12,137,150),
       ('Regno Unito','1',13,137,150),
       ('Regno Unito','1',14,137,150),
       ('Regno Unito','5',12,167,50),
       ('Regno Unito','14',14,274,250),
       ('Regno Unito','17',13,253,180),
       ('Regno Unito','13',12,222,200),
       ('Regno Unito','2',14,103,100),
       ('Regno Unito','9',14,196,100),
       ('Regno Unito','10',13,125,100),
       ('Regno Unito','6',12,106,50),
       ('Regno Unito','14',11,293,250),
       ('Regno Unito','3',13,142,150),
       ('Regno Unito','12',14,115,100),
       ('Regno Unito','16',12,253,200),
       ('Regno Unito','5',13,174,50),
       ('Regno Unito','13',11,297,200),
       ('Regno Unito','17',12,228,180),
       ('Regno Unito','9',11,200,100),
       ('Regno Unito','11',14,154,100),
       ('Regno Unito','6',11,137,50),
       ('Regno Unito','12',11,149,100),
       ('Regno Unito','3',11,152,150),
       ('Regno Unito','4',13,170,100),
       ('Regno Unito','7',11,190,20),
       ('Regno Unito','2',12,118,100),
       ('Regno Unito','5',11,149,50),
       ('Regno Unito','11',13,163,100),

       ('Spagna','1',15,119,150),
       ('Spagna','1',16,119,150),
       ('Spagna','1',17,119,150),
       ('Spagna','6',17,254,150),
       ('Spagna','11',16,163,100),
       ('Spagna','15',16,192,200),
       ('Spagna','16',17,284,200),
       ('Spagna','14',15,233,250),
       ('Spagna','7',17,175,20),
       ('Spagna','2',16,110,100),
       ('Spagna','12',15,142,100),
       ('Spagna','9',16,157,100),
       ('Spagna','3',17,162,150),
       ('Spagna','13',15,273,200),
       ('Spagna','8',16,187,100)


INSERT INTO Transazione
VALUES 
(1,'mario.rossi@gmail.com',1,"0.22","98.36","amazing.it","Mario Rossi","0.0",'5208928454728826','MasterCard'),
(2,'mario.rossi@gmail.com',2,"0.22","614.74","amazing.it","Mario Rossi","10.0",'5208928454728826','MasterCard'),
(3,'mario.rossi@gmail.com',3,"0.22","1557.37","amazing.it","Mario Rossi","0.0",'5208928454728826','MasterCard'),
(4,'pedro.sanchez@gmail.com',4,"0.21","4326.40","amazing.es","Pedro Sanchez","5.0",'4916958336059955','Visa'),
(5,'enrico.bianchi@gmail.com',5,"0.22","139.30","amazing.it","Enrico Bianchi","0.0",'5200595708846866','Visa'),
(6,'filippo.neri@yahoo.com',6,"0.22","1200.80","amazing.it","Filippo Neri","0.0",'6986861098354190','Visa'),
(7,'filippo.neri@yahoo.com',7,"0.22","151.63","amazing.it","Filippo Neri","5.0",'6986861098354190','Visa'),
(8,'mario.rossi@gmail.com',8,"0.22","405.70","amazing.it","Mario Rossi","0.0",'5208928454728826','MasterCard'),
(9,'mario.rossi@gmail.com',9,"0.22","114.65","amazing.it","Mario Rossi","10.0",'5208928454728826','MasterCard'),
(10,'enrico.rossi@gmail.com',10,"0.22","655.71","amazing.it","Mario Rossi","0.0",'5208928454728826','MasterCard'),
(11,'peterstigliz@yahoo.de',11,"0.19","621.84","amazing.de","Peter Stigliz","0.0",'4485459285117382','Visa'),
(12,'michaelbrown@hotmail.com',12,"0.20","58.28","amazing.uk","Michael Brown","0.0",'3146274394239412','Visa'),
(13,'michaelbrown@hotmail.com',13,"0.20","1587.50","amazing.uk","Michael Brown","5.0",'3146274394239412','Visa'),
(14,'francoispinot@yahoo.fr',14,"0.20","724.975","amazing.fr","Francois Pinot","0.0",'6478246218618631','MasterCard'),
(15,'alessandro.canesso@gmail.com',15,"0.22","81.96","amazing.it","Alessandro Canesso","0.0",'5616523532429286','MasterCard')
