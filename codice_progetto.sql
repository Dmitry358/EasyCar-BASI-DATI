SET FOREIGN_KEY_CHECKS=0;

DROP INDEX IF EXISTS idx_CodiceCliente ON Cliente;
DROP TABLE IF EXISTS Polizza;
DROP TABLE IF EXISTS Extra;
DROP TABLE IF EXISTS Prenotazione;
DROP TABLE IF EXISTS Multa;
DROP TABLE IF EXISTS Telefono;
DROP TABLE IF EXISTS Grafico;
DROP TABLE IF EXISTS Contratto_giornaliero;
DROP TABLE IF EXISTS Contratto_turnista;
DROP TABLE IF EXISTS Auto;
DROP TABLE IF EXISTS Sede;
DROP TABLE IF EXISTS Turno;
DROP TABLE IF EXISTS Turnista;
DROP TABLE IF EXISTS Giornaliero;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Tariffa;
DROP TABLE IF EXISTS Servizio;

CREATE TABLE Giornaliero(
	Matricola SMALLINT UNSIGNED PRIMARY KEY,
	CF VARCHAR(16) NOT NULL UNIQUE,
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20) NOT NULL,
	Nascita DATE NOT NULL,
	Luogo VARCHAR(40) NOT NULL,
	Provincia VARCHAR(2) NOT NULL,
	Ruolo SET('responsabile','contabile','manutentore') NOT NULL
);

CREATE TABLE Sede(
	Codice SMALLINT UNSIGNED PRIMARY KEY,
	Via VARCHAR(30) NOT NULL,
	Civico SMALLINT UNSIGNED NOT NULL,
	CAP MEDIUMINT UNSIGNED NOT NULL,
	Citta VARCHAR(40) NOT NULL,
	Provincia VARCHAR(2) NOT NULL,
	E_mail VARCHAR(40) NOT NULL UNIQUE, 
	Dirigente SMALLINT UNSIGNED,
	UNIQUE (Via, Civico, CAP, Citta, Provincia),
	FOREIGN KEY (Dirigente) REFERENCES Giornaliero(Matricola)
);

CREATE TABLE Tariffa(
	Categoria SET('piccola','media','grande','top') PRIMARY KEY,
	Costo DECIMAL (5,2) UNSIGNED NOT NULL 
);

CREATE TABLE Auto( 
	ID SMALLINT UNSIGNED PRIMARY KEY,
	Targa VARCHAR(7) NOT NULL UNIQUE,
	Tipologia SET ('lusso','sportiva','mini','standard','SUV','familiare','furgone') NOT NULL,
	Marca VARCHAR(20) NOT NULL,
	Modello VARCHAR(20) NOT NULL,
	Posti TINYINT UNSIGNED NOT NULL,
	Alimentazione SET ('benzina','diesel','elettrica','ibrida') NOT NULL,
	Cambio SET ('manuale','automatico') NOT NULL,
	Cod_sede SMALLINT UNSIGNED NOT NULL,
	Categoria SET ('piccola','media','grande','top'),
	FOREIGN KEY (Categoria) REFERENCES Tariffa(Categoria),
	FOREIGN KEY (Cod_sede) REFERENCES Sede(Codice)
);
 
CREATE TABLE Polizza( 
	Auto SMALLINT UNSIGNED REFERENCES Auto(ID),
	Emissione DATE,
	Scadenza DATE NOT NULL,
	PRIMARY KEY (Auto, Emissione)
);

CREATE TABLE Cliente(
	Codice MEDIUMINT UNSIGNED PRIMARY KEY,
	Patente VARCHAR(10) NOT NULL UNIQUE,
    Nome VARCHAR(20) NOT NULL,
    Cognome VARCHAR(20) NOT NULL,
    Telefono INT UNSIGNED,
    E_mail VARCHAR(40) NOT NULL UNIQUE,
	Accumulativo DECIMAL (7,2) UNSIGNED NOT NULL
);

CREATE TABLE Prenotazione(
	Numero INT PRIMARY KEY,
	ID_auto SMALLINT UNSIGNED NOT NULL,
    Cliente MEDIUMINT UNSIGNED NOT NULL,
    Conferma TIMESTAMP NOT NULL,
    Ritiro TIMESTAMP NOT NULL,
    Consegna TIMESTAMP NOT NULL,
    Totale DECIMAL (6,2) UNSIGNED NOT NULL,
	FOREIGN KEY (ID_auto) REFERENCES Auto(ID),
	FOREIGN KEY (Cliente) REFERENCES Cliente(Codice)
);

CREATE TABLE Servizio(
	Tipo SET('navigatore','rialzo','seggiolino','portasci','catene','tendine') PRIMARY KEY,
	Costo DECIMAL (4,2) UNSIGNED NOT NULL
);

CREATE TABLE Extra(
	N_prenotazione INT, 
	Tipo_servizio SET('navigatore','rialzo','seggiolino','portasci','catene','tendine'),
	PRIMARY KEY (N_prenotazione, Tipo_servizio),
	FOREIGN KEY (N_prenotazione) REFERENCES Prenotazione(Numero),
	FOREIGN KEY (Tipo_servizio) REFERENCES Servizio(Tipo)
);

CREATE TABLE Multa(
	Codice VARCHAR(10) PRIMARY KEY,
	Auto SMALLINT UNSIGNED NOT NULL,
	Cod_cliente MEDIUMINT UNSIGNED NOT NULL,
	Causale TINYTEXT NOT NULL,
	Data_ora TIMESTAMP NOT NULL,
	Importo DECIMAL (6,2) UNSIGNED NOT NULL,
	FOREIGN KEY (Auto) REFERENCES Auto(ID),
	FOREIGN KEY (Cod_cliente) REFERENCES Cliente(Codice)	
);

CREATE TABLE Telefono(
	Numero INT UNSIGNED PRIMARY KEY, 
	Cod_sede SMALLINT UNSIGNED NOT NULL,
	FOREIGN KEY (Cod_sede) REFERENCES Sede(Codice)
);

CREATE TABLE Turnista(
	Matricola SMALLINT UNSIGNED PRIMARY KEY,
	CF VARCHAR(16) NOT NULL UNIQUE,
	Nome VARCHAR(20) NOT NULL,
	Cognome VARCHAR(20) NOT NULL,
	Nascita DATE NOT NULL,
	Luogo VARCHAR(40) NOT NULL,
	Provincia VARCHAR(2) NOT NULL,
	Ruolo SET('receptionista','guardiano') NOT NULL
);

CREATE TABLE Turno(
	Tipologia SET('mattina','pomeriggio','notte') PRIMARY KEY,
	Inizio TIME NOT NULL,
	Fine TIME NOT NULL
);

CREATE TABLE Grafico(
	Turno SET('mattina','pomeriggio','notte'),
	Data DATE, 
	Matr_turnista SMALLINT UNSIGNED NOT NULL, 
	PRIMARY KEY (Turno,Data),
	FOREIGN KEY (Turno) REFERENCES Turno(Tipologia),
	FOREIGN KEY (Matr_turnista) REFERENCES Turnista(Matricola)
);

CREATE TABLE Contratto_giornaliero(
	Dipendente SMALLINT UNSIGNED, 
	Assunzione DATE, 
	Scadenza DATE DEFAULT NULL,
	Sede SMALLINT UNSIGNED NOT NULL,
	Salario DECIMAL (6,2) UNSIGNED NOT NULL,
	PRIMARY KEY (Dipendente,Assunzione), 
	FOREIGN KEY (Dipendente) REFERENCES Giornaliero(Matricola),
	FOREIGN KEY (Sede) REFERENCES Sede(Codice)	
);

CREATE TABLE Contratto_turnista(
	Dipendente SMALLINT UNSIGNED, 
	Assunzione DATE, 
	Scadenza DATE DEFAULT NULL,
	Sede SMALLINT UNSIGNED NOT NULL,
	Notturno BOOL NOT NULL,
	Paga DECIMAL (4,2) UNSIGNED NOT NULL,	
	PRIMARY KEY (Dipendente,Assunzione), 
	FOREIGN KEY (Dipendente) REFERENCES Turnista(Matricola),
	FOREIGN KEY (Sede) REFERENCES Sede(Codice)	
);

INSERT INTO Giornaliero (Matricola, CF, Nome, Cognome, Nascita, Luogo, Provincia, Ruolo) VALUES
('501', 'DFDGHB87R12A212F', 'Paolo',    'Rossi',    '1985-11-01', 'Napoli',     'NA', 'responsabile'),
('502', 'DSDCVF99H25K196L', 'Aldo',     'Blu',      '1998-12-31', 'Saccolongo', 'PD', 'manutentore'),
('503', 'FGDVCD84G10G112Z', 'Luisa',    'Gialli',   '1990-08-14', 'Pisa',       'PI', 'contabile'),
('504', 'KJHCDE56X30J147V', 'Mario',    'Rossi',    '1980-05-16', 'Milano',     'MI', 'manutentore'),
('505', 'ASDCVF76V21X564G', 'Paolo',    'Hulk',     '1984-10-05', 'Mestre',     'VE', 'responsabile'),
('506', 'BNGXCD52A56J452H', 'Isa',      'Gaiga',    '1969-04-06', 'Palermo',    'PA', 'manutentore'),
('507', 'ASDUYT58R22H258P', 'Uki',      'Vucinic',  '1996-06-14', 'Verona',     'VR', 'contabile'),
('508', 'MNBJUY54C33Q144Z', 'Mick',     'Gulag',    '1989-02-13', 'Belluno',    'BL', 'manutentore'),
('509', 'AAQCCV99B14J258G', 'Vladimir', 'Putin',    '1986-09-14', 'Bari',       'BA', 'responsabile'),
('510', 'BVBGYY45N11U747Q', 'Xavier',   'Zanetti',  '1990-03-19', 'Roma',       'RM', 'responsabile'),
('511', 'FGRYYU98F58G447A', 'Daniele',  'DeRossi',  '1992-05-30', 'Firenze',    'FI', 'responsabile'),
('512', 'DDSCFD47X98G636Q', 'Ugo',      'Fantozzi', '1984-10-03', 'Salerno',    'SA', 'responsabile'),
('513', 'MMMGHB88R12A212F', 'Luisa',    'Rossi',    '1988-11-01', 'Napoli',     'NA', 'manutentore');

INSERT INTO Sede (Codice, Via, Civico, CAP, Citta, Provincia, E_mail, Dirigente) VALUES
('1', 'Via dell Industria',  '26', '35100', 'Padova', 'PD', 'padova1@easycar.it', '501'),
('2', 'Viale delle Nazioni', '5',  '20089', 'Milano', 'MI', 'milano1@easycar.it', '511'),
('3', 'Via Uruguay',         '10', '37100', 'Verona', 'VR', 'verona1@easycar.it', '508'),
('4', 'Via Vittorio Veneto', '5',  '10150', 'Torino', 'TO', 'torino1@easycar.it', '507'),
('5', 'Via Piave',           '29', '30171', 'Mestre', 'VE', 'mestre1@easycar.it', '504'),
('6', 'Via Vittorio Veneto', '5',  '10151', 'Torino', 'TO', 'torino2@easycar.it', '505');

INSERT INTO Tariffa (Categoria, Costo) VALUES
('piccola', '18.0'),
('media',   '20.0'),
('grande',  '30.0'),
('top',     '50.0');

INSERT INTO Auto (ID, Targa, Tipologia, Marca, Modello, Posti, Alimentazione, Cambio, Cod_sede, Categoria) VALUES
('101', 'BA558VX', 'standard',  'Fiat',       'Punto',   '5', 'benzina',   'manuale',    '5', 'media'),
('102', 'CW554HG', 'mini',      'Toyota',     'Aygo',    '4', 'benzina',   'manuale',    '1', 'piccola'),
('103', 'DF665XZ', 'mini',      'Volkswagen', 'Lupo',    '4', 'diesel',    'manuale',    '1', 'piccola'),
('104', 'CH145JH', 'standard',  'Fiat',       'Punto',   '5', 'diesel',    'manuale',    '5', 'media'),
('105', 'FG787AH', 'SUV',       'Alfa Romeo', 'Stelvio', '5', 'diesel',    'automatico', '1', 'grande'),
('106', 'AG567NM', 'familiare', 'Fiat',       'Marea',   '5', 'diesel',    'manuale',    '3', 'media'),
('107', 'CW445GE', 'furgone',   'Fiat',       'Fiorino', '2', 'diesel',    'manuale',    '2', 'grande'),
('108', 'DF223CV', 'lusso',     'Mercedes',   'ClasseC', '5', 'benzina',   'automatico', '1', 'top'),
('109', 'ED447WE', 'lusso',     'Tesla',      'ModelS',  '5', 'elettrica', 'automatico', '5', 'top'),
('110', 'EG811VB', 'familiare', 'Toyota',     'Avensis', '5', 'ibrida',    'automatico', '3', 'media'),
('111', 'DF885BS', 'sportiva',  'Fiat',       '124',     '2', 'benzina',   'manuale',    '1', 'top'),
('112', 'DH554AA', 'mini',      'Fiat',       'Panda',   '4', 'benzina',   'manuale',    '1', 'piccola'),
('113', 'DW122AC', 'mini',      'Fiat',       'Panda',   '4', 'benzina',   'manuale',    '1', 'piccola'),
('114', 'ED125AS', 'mini',      'Fiat',       '500',     '4', 'benzina',   'automatico', '2', 'piccola'),
('115', 'DL445GE', 'mini',      'Fiat',       '500',     '4', 'benzina',   'automatico', '2', 'piccola'),
('116', 'VF567NM', 'familiare', 'Fiat',       'Marea',   '5', 'diesel',    'manuale',    '4', 'media'),
('117', 'FG000AH', 'SUV',       'Alfa Romeo', 'Stelvio', '5', 'diesel',    'automatico', '6', 'grande');

INSERT INTO Polizza (Auto, Emissione, Scadenza) VALUES
('101',  '2018-11-15 00:00:00', '2020-11-14 23:59:59'),
('102',  '2018-06-15 00:00:00', '2019-06-14 23:59:59'),
('103',  '2018-01-10 00:00:00', '2020-01-09 23:59:59'),
('104',  '2019-06-01 00:00:00', '2020-05-30 23:59:59'),
('105',  '2019-10-15 00:00:00', '2020-10-14 23:59:59'),
('106',  '2019-02-05 00:00:00', '2021-02-04 23:59:59'),
('107',  '2019-12-15 00:00:00', '2020-06-14 23:59:59'),
('108',  '2019-05-01 00:00:00', '2020-04-30 23:59:59'),
('109',  '2019-01-15 00:00:00', '2021-01-14 23:59:59'),
('110',  '2019-10-01 00:00:00', '2020-03-31 23:59:59'),
('111',  '2019-07-15 00:00:00', '2020-07-14 23:59:59'),
('112',  '2019-08-01 00:00:00', '2020-07-31 23:59:59'),
('113',  '2019-11-10 00:00:00', '2020-11-09 23:59:59'),
('114',  '2019-09-15 00:00:00', '2020-09-14 23:59:59'),
('115',  '2019-11-16 00:00:00', '2020-05-15 23:59:59');

INSERT INTO Cliente (Codice, Patente, Nome, Cognome, Telefono, E_mail, Accumulativo) VALUES
('201', 'VR6545212G', 'Claudio', 'Rossi',    '3251122433', 'abc@xxx.com',    '200.50'),
('202', 'AN5521212N', 'Marco',   'Rossi',    '3391212128', 'def@yyy.it',     '180.90'),
('203', 'MI4456786K', 'Paolo',   'Verdi',     NULL,        'ggg@abc.com',    '2010.40'),
('204', 'NA2245632N', 'Luca',    'Galli',    '3361217216', 'abh@xxx.com',    '345.60'),
('205', 'RM4521523S', 'Stefano', 'Bianchi',   NULL,        'hghd@hud.com',   '123.40'),
('206', 'BA4512562K', 'Giorgio', 'Bianchi',  '3487868152', 'abvv@xxx.com',   '2300.70'),
('207', 'PD4121498U', 'Claudio', 'Blu',       NULL,        'g23@abc.com',    '2560.80'),
('208', 'UD4212363L', 'Laura',   'Esposito', '3794512219', 'hss245@hud.com', '60.40'),
('209', 'BA4512136A', 'Claudio', 'Rossi',    '3351122333', 'g117@abc.com',   '450.80'),
('210', 'BS4521553F', 'Claudio', 'Rossi',    '3291122533', 'hkl78@hud.com',  '780.90'),
('211', 'FI5452351E', 'Laura',   'Verdi',    '3784512219', 'dgh56@yyy.it',   '350.60'),
('212', 'GE4574512D', 'Claudio', 'Blu',      '3251122533', 'av678@xxx.com',  '30.70'),
('213', 'VR4517899K', 'Mauro',   'Rossi',    '3251125633', 'ggk98@abc.com',  '60.50'),
('214', 'NA2442632S', 'Luca',    'Valli',    '3361245216', 'abvd51@xxx.com', '140');

INSERT INTO Prenotazione (Numero, ID_auto, Cliente, Conferma, Ritiro, Consegna, Totale) VALUES
('301', '101', '201', '2019-09-28 17:56:36', '2019-11-15 10:00:00', '2019-11-18 11:00:00', '54.00'),
('302', '103', '201', '2019-10-05 12:54:12', '2019-12-23 10:00:00', '2019-12-28 11:00:00', '90.00'),
('303', '111', '203', '2019-10-15 05:50:52', '2019-11-18 10:00:00', '2019-11-22 11:00:00', '200.00'),
('304', '107', '204', '2019-11-01 09:01:11', '2019-12-02 10:00:00', '2019-12-12 11:00:00', '300.00'),
('305', '108', '205', '2019-11-03 18:55:11', '2019-12-02 10:00:00', '2019-12-08 11:00:00', '310.00'),
('306', '103', '206', '2019-11-05 02:14:30', '2019-12-04 10:00:00', '2019-12-05 11:00:00', '18.00'),
('307', '110', '207', '2019-11-08 16:33:48', '2019-11-16 10:00:00', '2019-11-20 11:00:00', '120.00'),
('308', '102', '201', '2019-11-09 10:05:04', '2019-12-25 10:00:00', '2019-12-27 11:00:00', '36.00'),
('309', '103', '202', '2019-12-02 14:05:04', '2019-12-06 10:00:00', '2019-11-08 11:00:00', '36.00'),
('310', '102', '203', '2019-12-04 16:05:04', '2019-12-08 10:00:00', '2019-12-10 11:00:00', '36.00'),
('311', '103', '208', '2019-12-05 14:05:04', '2019-12-09 10:00:00', '2019-12-10 11:00:00', '18.00'),
('312', '103', '211', '2019-12-06 08:45:04', '2019-12-11 10:00:00', '2019-12-13 11:00:00', '56.00'),
('313', '103', '211', '2019-12-08 22:25:04', '2019-12-14 10:00:00', '2019-12-16 11:00:00', '36.00'),
('314', '103', '213', '2019-12-09 08:45:04', '2019-12-17 10:00:00', '2019-12-18 11:00:00', '18.00'),
('315', '103', '207', '2019-12-10 22:25:04', '2019-12-19 10:00:00', '2019-12-22 11:00:00', '54.00'),
('316', '102', '202', '2019-12-11 16:05:04', '2019-12-08 10:00:00', '2019-12-10 11:00:00', '36.00'),
('317', '102', '214', '2019-12-12 12:05:04', '2019-12-13 10:00:00', '2019-12-16 11:00:00', '54.00'),
('318', '102', '206', '2019-12-12 12:05:04', '2019-12-13 10:00:00', '2019-12-16 11:00:00', '54.00'),
('319', '114', '207', '2019-12-12 12:05:04', '2019-12-13 10:00:00', '2019-12-16 11:00:00', '54.00'),
('320', '115', '208', '2019-12-12 12:05:04', '2019-12-13 10:00:00', '2019-12-16 11:00:00', '54.00'),
('321', '116', '201', '2019-11-19 10:05:04', '2019-12-25 10:00:00', '2019-12-27 11:00:00', '36.00'),
('322', '116', '202', '2019-12-02 14:05:04', '2019-12-06 10:00:00', '2019-12-08 11:00:00', '36.00'),
('323', '117', '203', '2019-12-04 16:05:04', '2019-12-08 10:00:00', '2019-12-10 11:00:00', '36.00'),
('324', '115', '202', '2019-11-04 16:05:04', '2019-11-08 10:00:00', '2019-11-10 11:00:00', '56.00');

INSERT INTO Servizio (Tipo, Costo) VALUES
('seggiolino',  '15.0'),
('portapacchi', '10.0'),
('tendine',     '10.0'),
('portasci',    '15.0'),
('catene',      '10.0'),
('navigatore',  '10.0'),
('rialzo',      '8.0');

INSERT INTO Extra (N_prenotazione, Tipo_servizio) VALUES
('303', 'seggiolino'),
('312', 'tendine'),
('304', 'rialzo'),
('301', 'portapacchi'),
('311', 'catene'),
('304', 'tendine'),
('320', 'tendine'),
('324', 'tendine');

INSERT INTO Telefono(Numero, Cod_sede) VALUES
('0493652123', '5'),
('0514562351', '1'),
('0214525455', '2'),
('0474562368', '3'),
('0847855133', '4');

INSERT INTO Multa (Codice, Auto, Cod_cliente, Causale, Data_ora, Importo) VALUES
('401', '103', '203', 'Divieto di sosta',   '2019-12-12 12:05:04', '24.3'),
('402', '102', '206', 'Eccesso velocita',   '2019-12-11 16:05:04', '25.6'),
('403', '110', '203', 'Eccesso velocita',   '2019-12-10 22:25:04', '36.8'),
('404', '111', '202', 'Divieto di sosta',   '2019-12-09 08:45:04', '45.6'),
('406', '114', '214', 'Guida pericolosa',   '2019-12-08 22:25:04', '80.9'),
('407', '111', '211', 'Mancata precedenza', '2019-12-06 08:45:04', '45.6'),
('408', '103', '209', 'Eccesso velocita',   '2019-12-05 14:05:04', '34'),
('409', '114', '205', 'Divieto di sosta',   '2019-12-04 16:05:04', '56.8'),
('410', '110', '204', 'Eccesso velocita',   '2019-12-02 14:05:04', '12.3'),
('411', '102', '208', 'Divieto di sosta',   '2019-11-09 10:05:04', '56.8'),
('412', '103', '210', 'Guida pericolosa',   '2019-11-08 16:33:48', '45.6'),
('413', '103', '212', 'Eccesso velocita',   '2019-11-05 02:14:30', '34'),
('414', '107', '213', 'Divieto di sosta',   '2019-11-03 18:55:11', '56'),
('415', '111', '207', 'Mancata precedenza', '2019-11-01 09:01:11', '28.7'),
('416', '107', '209', 'Eccesso velocita',   '2019-10-15 05:50:52', '56.7'),
('417', '114', '208', 'Divieto di sosta',   '2019-10-05 12:54:12', '28.9'),
('418', '104', '202', 'Mancata precedenza', '2019-09-28 17:56:36', '40.9'),
('419', '103', '201', 'Divieto di sosta',   '2017-12-12 12:05:04', '24.3'),
('420', '117', '214', 'Guida pericolosa',   '2019-12-08 22:25:04', '90.9'),
('421', '115', '205', 'Divieto di sosta',   '2019-11-04 16:05:04', '36.8'),
('422', '116', '205', 'Divieto di sosta',   '2019-10-04 16:05:04', '76.8');

INSERT INTO Turnista (Matricola, CF, Nome, Cognome, Nascita, Luogo, Provincia, Ruolo) VALUES
('620', 'ROSMAU90P11Z123M', 'Mauro',   'Rossi',   '1990-12-12', 'Napoli',  'NA', 'guardiano'),
('621', 'STEVER87D12X234N', 'Stefano', 'Verdi',   '1987-07-13', 'Milano',  'MI', 'receptionista'),
('622', 'CLABIA67Q23H569M', 'Claudio', 'Bianchi', '1967-03-11', 'Belluno', 'BL', 'receptionista'),
('623', 'LUICON78B12I678Z', 'Luigi',   'Conti',   '1978-04-15', 'Ferrara', 'FE', 'guardiano'),
('624', 'IVALIN82C23H234G', 'Ivan',    'Linpeng', '1982-02-16', 'Como',    'CO', 'receptionista'),
('625', 'MARBIA91J45N321R', 'Mario',   'Bianchi', '1981-06-12', 'Bologna', 'BO', 'receptionista'),
('626', 'MARROS91J45N321B', 'Mario',   'Rossi',   '1991-06-12', 'Bologna', 'BO', 'receptionista'),
('627', 'STEBIA67V65D765X', 'Stefano', 'Bianchi', '1967-03-10', 'Siena',   'SI', 'receptionista'),
('628', 'LUIVER88Z88X234Z', 'Luigi',   'Verdi',   '1988-02-14', 'Firenze', 'FI', 'receptionista'),
('629', 'STECON79U79D123A', 'Stefano', 'Conti',   '1979-07-11', 'Milano',  'MI', 'receptionista'),
('630', 'GIUBIA87X56F576Z', 'Giulio',  'Bianchi', '1987-02-16', 'Firenze', 'FI', 'receptionista'),
('631', 'MARVER88S23K465S', 'Mario',   'Verdi',   '1988-05-23', 'Padova',  'PD', 'guardiano'),
('632', 'IVAPET80F63J876W', 'Ivan',    'Petrov',  '1980-10-18', 'Venezia', 'VE', 'receptionista'),
('633', 'LORROS60H45R254W', 'Lorenzo', 'Rossi',   '1960-09-09', 'Milano',  'MI', 'receptionista'),
('634', 'MAUIBR54S83T354Z', 'Mauro',   'Ibra',    '1954-07-02', 'Firenze', 'FI', 'receptionista'),
('635', 'CLARON60A54N867A', 'Claudio', 'Ronaldo', '1960-01-08', 'Mestre',  'ME', 'guardiano'),
('636', 'LORVER78K23N564S', 'Lorenzo', 'Verdi',   '1978-08-19', 'Milano',  'MI', 'receptionista');

INSERT INTO Turno (Tipologia, Inizio, Fine) VALUES
('mattina',    '6:00',  '14:00'),
('pomeriggio', '14:00', '22:00'),
('notte',      '22:00', '6:00');

INSERT INTO Grafico (Turno, Data, Matr_turnista) VALUES
('mattina',    '2019-11-11', '623'),
('pomeriggio', '2019-11-11', '626'),
('notte',      '2019-11-11', '621'),
('mattina',    '2019-11-12', '633'),
('pomeriggio', '2019-11-12', '630'),
('notte',      '2019-11-12', '622'),
('mattina',    '2019-11-13', '626'),
('pomeriggio', '2019-11-13', '628'),
('notte',      '2019-11-13', '625'),
('mattina',    '2019-11-14', '622'),
('pomeriggio', '2019-11-14', '631'),
('notte',      '2019-11-14', '624'),
('mattina',    '2019-11-15', '632'),
('pomeriggio', '2019-11-15', '633'),
('notte',      '2019-11-15', '627'),
('mattina',    '2019-11-16', '624'),
('pomeriggio', '2019-11-16', '626'),
('notte',      '2019-11-16', '629'),
('mattina',    '2019-11-17', '628'),
('pomeriggio', '2019-11-17', '621'),
('notte',      '2019-11-17', '631'),
('mattina',    '2019-11-18', '633'),
('pomeriggio', '2019-11-18', '636'),
('notte',      '2019-11-19', '632');

INSERT INTO Contratto_giornaliero (Dipendente, Assunzione, Scadenza, Sede, Salario) VALUES
('501',  '2018-01-01', '2018-06-30', '1', '2000'),
('501',  '2018-09-01', '2021-06-30', '2', '1200'),
('502',  '2019-02-01', '2021-12-31', '2', '1500'),
('503',  '2015-01-31', '2016-01-31', '1', '1300'),
('503',  '2016-06-01', '2017-05-31', '4', '1800'),
('503',  '2017-09-15', '2020-06-30', '3', '900'),
('504',  '2018-01-01', '2021-12-31', '3', '1500'),
('505',  '2017-01-01', '2022-12-31', '3', '1000'),
('506',  '2018-01-31', '2020-01-31', '1', '1300'),
('507',  '2019-02-01', '2019-06-30', '4', '1700'),
('507',  '2019-07-01', '2019-10-31', '5', '1200'),
('507',  '2019-12-01', '2020-06-30', '4', '1200'),
('508',  '2019-04-01', '2020-03-30', '6', '2000'),
('509',  '2018-01-01', '2019-01-01', '1', '1100'),
('509',  '2019-02-01', '2020-06-01', '5', '1500'),
('510',  '2019-01-01', '2022-01-01', '4', '1600'),
('511',  '2019-03-01', '2022-01-01', '2', '1200'),
('512',  '2019-01-01', '2021-02-01', '6', '1300');

INSERT INTO Contratto_turnista (Dipendente, Assunzione, Scadenza, Sede, Notturno, Paga) VALUES
('620', '2019-10-12',  NULL,        '2', true,  '8.9'),
('621', '2018-09-11', '2018-10-11', '3', true,  '9.3'),
('621', '2019-03-02',  NULL,        '1', true,  '7.4'),
('622', '2019-02-07', '2020-03-14', '5', false, '7.5'),
('623', '2017-02-03', '2018-02-03', '6', true,  '8.2'),
('624', '2019-04-05',  NULL,        '1', false, '7.9'),
('625', '2019-05-01', '2019-10-01', '4', false, '7.9'),
('626', '2016-04-05', '2016-10-05', '5', true,  '9'),
('626', '2019-01-01',  NULL,        '1', true,  '8.9'),
('627', '2019-08-10', '2019-10-10', '4', true,  '8.3'),
('628', '2018-01-02', '2018-05-02', '3', false, '8.1'),
('629', '2019-01-07', '2019-10-07', '2', true,  '7.8'),
('630', '2019-03-05', '2019-03-05', '5', true,  '9.2'),
('631', '2019-01-06', '2019-11-06', '6', false, '8.6'),
('631', '2017-11-12', '2018-11-12', '4', false, '8.6'),
('631', '2018-11-12', '2019-11-12', '1', true,  '7.8'),
('632', '2017-06-07',  NULL,        '2', true,  '8.6'),
('633', '2019-08-09', '2019-12-09', '5', true,  '8.3'),
('634', '2018-07-08', '2019-07-08', '1', false, '8.6'),
('635', '2016-05-06', '2019-05-06', '6', true,  '8.2'),
('636', '2019-01-02',  NULL,        '6', true,  '8.4');

SET FOREIGN_KEY_CHECKS=1;


/*QUERY 1: Stampare l'elenco dei clienti (Codice, Nome, Cognome, E_mail) che hanno eseguito piu di due prenotazioni in 
tutto tempo e non hanno mai preso multe dal 01/01/19 al 31/11/19.*/

SELECT Codice, Nome, Cognome, E_mail
FROM  Cliente 
WHERE Codice = ANY (SELECT Cliente 
                    FROM Prenotazione
                    GROUP BY Cliente
                    HAVING COUNT(Cliente)>2) 
      AND 
      Codice NOT IN (SELECT DISTINCT Cod_cliente 
                     FROM Multa
                     WHERE Data_ora >= '2019-01-01 00:00:00' AND Data_ora < '2019-12-01 00:00:00');	


/*QUERY 2: Stampare in ordine decrescente l'elenco dei codici delle sedi, la loro citta di appartenenza e il fatturato 
per la tipologia "mini" nel periodo da 1/12/19 a 18/12/19 escluso. Scegliere solo le sedi dove il sudetto fatturato e 
maggiore di 100 euro.*/

SELECT A.Cod_sede AS Sede, S.Citta AS Citta, SUM(P.Totale) AS Fatturato
FROM Prenotazione P JOIN Auto A ON A.ID = P.ID_auto JOIN Sede S ON S.Codice = A.Cod_sede
WHERE  A.Tipologia = 'mini' AND P.Conferma >= '2019-12-01 00:00:00' AND P.Conferma < '2019-12-18 00:00:00'
GROUP BY A.Cod_sede
HAVING SUM(P.Totale)>100
ORDER BY A.Cod_sede DESC;


/*QUERY 3: Elenco dei codici delle sedi dove non sono mai state prenotate le auto di tipologia 'mini' o sedi dove il 
salario medio di tutti i giornalieri e maggiore di 1400 euro.*/

SELECT S.Codice AS SEDE
FROM Sede S
WHERE S.Codice NOT IN (SELECT A.Cod_sede
                       FROM Auto A JOIN Prenotazione P ON A.ID = P.ID_auto
                       WHERE A.Tipologia = 'mini')
UNION
   SELECT CG.Sede AS SEDE
   FROM Contratto_giornaliero CG
   GROUP BY CG.Sede
   HAVING avg(CG.Salario) > 1400;


/*QUERY 4: L'elenco dei codici, cognomi in ordine decrescente, nomi dei clienti che hanno prenotato in totale per piu di 
100 euro e totale delle multe che hanno preso loro con le auto appartenti alle sedi di Milano e Torino.*/

SELECT C.Codice AS Codice, Cognome, Nome, SUM(M.Importo) AS Totale 
FROM Cliente C JOIN Multa M ON C.Codice = M.Cod_cliente
WHERE C.Accumulativo > 100 
      AND 
	  M.Auto IN (SELECT ID
                 FROM Auto A JOIN Sede S ON A.Cod_sede = S.Codice
                 WHERE S.Citta = 'Milano' OR S.Citta = 'Torino')
GROUP BY C.Codice
ORDER BY Cognome DESC;


/*QUERY 5: Stampare l'elenco delle targhe e la tipologia delle auto con le quali il servizio "tendine" e stato 
prenotato almeno 2 volte in tutto il tempo e queste auto non hanno mai preso multe nel dicembre 2019.*/

SELECT A.Targa AS Targa, A.Tipologia AS Tipologia
FROM  Prenotazione P JOIN Auto A ON P.ID_auto = A.ID JOIN Extra E ON P.Numero = E.N_prenotazione
WHERE E.Tipo_servizio = 'tendine' 
AND A.ID <> ALL (SELECT Auto
                 FROM Multa
                 WHERE Data_ora >=  '2019-12-01 00:00:00' AND Data_ora < '2020-01-01 00:00:00')
GROUP BY A.ID
HAVING COUNT(*) > 1;


/*QUERY 6: Stampare l'ID e il fatturato complessivo massimo di un'auto che appartiene ad una sede che e l'unica nella 
sua citta.*/

SELECT A.ID, SUM(P.Totale)
FROM Auto A JOIN Prenotazione P ON P.ID_auto = A.ID
WHERE A.Cod_sede IN (SELECT S.Codice
                     FROM Sede S
                     WHERE NOT EXISTS (SELECT S1.Citta
                                       FROM Sede S1
                                       WHERE S.Citta = S1.Citta AND S.Codice <> S1.Codice))
GROUP BY A.ID
ORDER BY SUM(P.Totale) DESC
LIMIT 1;

/*7. Creazione indice.*/

CREATE INDEX idx_CodiceCliente ON Cliente (Codice);
