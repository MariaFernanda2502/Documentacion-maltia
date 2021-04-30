CREATE TABLE dbo.employees (
	userId int IDENTITY(1,1) PRIMARY KEY,
	contrasena varchar(25) NOT NULL,
	nombre varchar(45) NOT NULL,
	apellidoPaterno varchar(45) NOT NULL,
	apellidoMaterno varchar(45) NOT NULL,
	correo varchar(45) NOT NULL UNIQUE,
	telefono bigint NOT NULL,
	puesto varchar(10) CHECK (puesto in('Asesor', 'Administrador', 'Analista')) NOT NULL,
);

CREATE TABLE dbo.advisers (
	userId int,
	PRIMARY KEY (userId),
	FOREIGN KEY (userId) REFERENCES employees(userId)
);

CREATE TABLE dbo.analysts (
	userId int,
	departamento varchar(25) NOT NULL DEFAULT 'OFICINA CENTRAL',
	PRIMARY KEY (userId),
	FOREIGN KEY (userId) REFERENCES employees(userId)
);

CREATE TABLE dbo.stores (
	storeId varchar(4),
	userAdviserId int,
	direccion varchar(30),
	nombre varchar(30) NOT NULL,
	PRIMARY KEY (storeId),
	FOREIGN KEY (userAdviserId) REFERENCES advisers(userId)
);

CREATE TABLE dbo.prospects (
	prospectId int IDENTITY(1,1) PRIMARY KEY,
	userAdviserId int,
	storeId varchar(4),
	nombre varchar(20) NOT NULL, 
	apellidoPaterno varchar(20) NOT NULL,
	apellidoMaterno varchar(20) NOT NULL,
	telefono bigint NOT NULL,
	contacto1 date,
	compromiso1 varchar(50),
	contacto2 date,
	compromiso2 varchar(50),
	contacto3 date, 
	compromiso3 varchar(50),
	FOREIGN KEY (userAdviserId) REFERENCES advisers(userId),
	FOREIGN KEY (storeId) REFERENCES stores(storeId) 
);

CREATE TABLE dbo.borrowers (
	prospectId int,
	numClienteZorro bigint,
	fechaNacimiento date,
	firmaBuro bit,
	ine bit,
	direccion varchar(25),
	nombreReferenciaUno varchar(40),
	telefonoReferenciaUno bigint,
	nombreReferenciaDos varchar(40),
	telefonoReferenciaDos bigint,
	PRIMARY KEY (prospectId),
	FOREIGN KEY (prospectId) REFERENCES prospects(prospectId)
);

CREATE TABLE dbo.clientapplications (
	clientApplicationId int IDENTITY(1,1) PRIMARY KEY,
	userAdviserId int,
	userAnalystId int,
	prospectId int UNIQUE,
	revisionMesa bit,
	altaISI bit,
	fechaAltaISI date, 
	antiguedad int,
	creditoSolicitado int,
	capacidadPago int,
	creditoAutorizado int,
	fechaAutorizacion date,
	estatus varchar(15) CHECK (estatus in('Aprobado', 'Rechazado', 'En proceso')) DEFAULT 'En proceso',
	tipoCredito varchar(15) CHECK(tipoCredito IN('Simple', 'Revolvente')),
	FOREIGN KEY (userAdviserId) REFERENCES advisers(userId),
	FOREIGN KEY (userAnalystId) REFERENCES analysts(userId),
	FOREIGN KEY (prospectId) REFERENCES borrowers(prospectId)
);

CREATE TABLE dbo.reports (
	reportId int IDENTITY(1,1) PRIMARY KEY,
	userAnalystId int,
	tipoReporte varchar (15)CHECK (tipoReporte in('Diario', 'Semanal', 'Mensual')),
	solicitudesAceptadas int,
	solicitudesRechazadas int,
	FOREIGN KEY (userAnalystId) REFERENCES analysts(userId)
);


/*
/*Triggers*/
CREATE TRIGGER maximaCantidad ON clientapplications INSTEAD OF UPDATE AS 
BEGIN 
	DECLARE @New_creditoSolicitado int, @New_creditoAutorizado int, @New_clientApplicationId int;
	SET @New_creditoSolicitado = (SELECT creditoSolicitado FROM INSERTED);
	SET @New_creditoAutorizado = (SELECT creditoAutorizado FROM INSERTED);
	SET @New_clientApplicationId = (SELECT clientApplicationId FROM INSERTED);
	IF(@New_creditoSolicitado > 80000) 
    	SET @New_creditoSolicitado = 80000;
    IF(@New_creditoAutorizado > 80000) 
    	SET @New_creditoAutorizado = 80000;
    UPDATE CLIENTAPPLICATIONS
    SET creditoSolicitado = @New_creditoSolicitado, creditoAutorizado = @New_creditoAutorizado
    WHERE clientApplicationId = @New_clientApplicationId
END;

/*Procedures*/
CREATE PROCEDURE solicitudes @estatus varchar(20) AS 
SELECT COUNT(clientapplicationId) FROM clientapplications WHERE estatus = @estatus;

/*EXEC solicitudes 'Aprobado';*/
*/
 
INSERT INTO employees  VALUES
('Contraseña1', 'Efren', 'Aldana', 'Escalona', 'ehafaffren@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Fer', 'Aldana', 'Escalona', 'een@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Vic', 'Aldana', 'Escalona', 'ren@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Alan', 'Aldana', 'Escalona', 'efewfren@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Luis', 'Aldana', 'Escalona', 'efrefren@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Adfrian', 'Aldana', 'Escalona', 'efdaren@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'ape', 'Aldana', 'Escalona', 'efreawden@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Dylan', 'Aldana', 'Escalona', 'efrecn@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'LALO', 'Aldana', 'Escalona', 'efrecadn@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'CARLOS', 'Aldana', 'Escalona', 'efrfeecadn@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Nachito', 'Aldana', 'Escalona', 'efrecdaen@gmail', 5564257022, 'Asesor'),
('Contraseña1', 'Carlos', 'Aldana', 'Escalona', 'efrenyh@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Clara', 'Aldana', 'Escalona', 'efrehyhyn@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Efren', 'Aldana', 'Escalona', 'efrenede@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Fer', 'Aldana', 'Escalona', 'efrenrfr@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Vic', 'Aldana', 'Escalona', 'efrenfew@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Alan', 'Aldana', 'Escalona', 'efrefwen@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Luis', 'Aldana', 'Escalona', 'efrewfen@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Adfrian', 'Aldana', 'Escalona', 'efrwfeen@gmail', 5564257022, 'Analista'),
('Contraseña1', 'ape', 'Aldana', 'Escalona', 'efrenhyt@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Dylan', 'Aldana', 'Escalona', 'efrejun@gmail', 5564257022, 'Analista'),
('Contraseña1', 'LALO', 'Aldana', 'Escalona', 'efrejn@gmail', 5564257022, 'Analista'),
('Contraseña1', 'CARLOS', 'Aldana', 'Escalona', 'efrneen@gmail', 5564257022, 'Analista'),
('Contraseña1', 'Carlos', 'Aldana', 'Escalona', 'efrejafnn@gmail', 5564257022, 'Analista');


INSERT INTO advisers VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11);
INSERT INTO analysts VALUES
(12, 'OFICINA CENTRAL'),
(13, 'OFICINA CENTRAL'),
(14, 'OFICINA CENTRAL'),
(15, 'OFICINA CENTRAL'),
(16, 'OFICINA CENTRAL'),
(17, 'OFICINA CENTRAL'),
(18, 'OFICINA CENTRAL'),
(19, 'OFICINA CENTRAL'),
(20, 'OFICINA CENTRAL'),
(21, 'OFICINA CENTRAL'),
(22, 'OFICINA CENTRAL'),
(23, 'OFICINA CENTRAL'),
(24, 'OFICINA CENTRAL');


INSERT INTO stores (storeId, nombre)  VALUES 
('CCA', 'CAZADOR COMERCIAL'),
('FAX', 'FLECHA ABARROTERA'),
('PNA', 'PROFETA NAUCALPAN'),
('PSU', 'CAZADOR SANTA URSULA'),
('ZAC', 'ZORRO AVENIDA CENTRAL'),
('ZA3', 'ZORRO ALTA TENSION 3'),
('ZAL', 'ZORRO ALTA TENSION'),
('ZA2', 'ZORRO ALTA TENSION 2'),
('ZAM', 'ZORRO AMECAMECA'),
('ZAT', 'ZORRO ATIZAPAN'),
('ZAZ', 'ZORRO CIEN METROS'),
('ZCA', 'ZORRO CENTRAL C47'),
('ZCC', 'ZORRO CARR CUERNAVACA'),
('ZCE', 'ZORRO CENTENARIO'),
('ZCH', 'ZORRO CHICOLOAPAN'),
('ZCJ', 'ZORRO CUAJIMALPA'),
('ZCL', 'ZORRO CHALCO'),
('ZCM', 'ZORRO CHIMALHUACAN'),
('ZCN', 'ZORRO CUAUTITLAN '),
('ZCO', 'ZORRO CONTRERAS'),
('ZC2', 'ZORRO CONTRERAS 2'),
('ZCP', 'ZORRO CARRILLO PUERTO'),
('ZCU', 'ZORRO CUAUTEPEC '),
('ZCV', 'ZORRO CALZADA LA VIGA'),
('ZE9', 'ZORRO CENTRAL E9'),
('ZEC', 'ZORRO ECATEPEC '),
('ZE2', 'ZORRO CENTRAL ECATEPEC 2'),
('ZRY', 'ZORRO REYES'),
('ZV2', 'VALLE DE CHALCO 2'),
('ZTM', 'SUCURSAL TECAMAC 2'),
('ZTE', 'TEXCOCO 2'),
('ZOC', 'ZORRO COACALCO'),
('ZNZ', 'NEZAHUALCOYOTL'),
('ZIZ', 'ZORRO CUAUTITLAN IZCALLI'),
('ZAG', 'SUCURSAL ARAGON'),
('ZHH', 'SUCURSAL HUEHETOCA'),
('ZL2', 'SUCURSAL CAMPESTRE'),
('ZM2', 'ZORRO PEÑON'),
('ZVM', 'ZORRO VIA MORELOS '),
('ZPC', 'ZORRO PASEO CHALCO'),
('ZMI', 'MINAS'),
('ZGP', 'SUCURSAL AGRICOLA PANTITLAN'),
('ZSM', 'SUCURSAL SANTA MARÍA'),
('ZQB', 'SUCURSAL BELÉN'),
('ZQA', 'SUCURSAL CEDA QUERETARO'),
('ZMR', 'SUCURSAL MINERAL DE LA REFORMA'),
('ZI2', 'SUCURSAL IGUALA 2'),
('ZER', 'ZORRO ERMITA'),
('ZES', 'ZORRO ESTACAS'),
('ZH2', 'ZORRO CENTRAL  H2 '),
('ZIG', 'ZORRO IGUALA '),
('ZJI', 'ZORRO JIUTEPEC'),
('ZJR', 'ZORRO SAN JUAN DEL RIO'),
('ZLG', 'ZORRO LAGO DE GUADALUPE'),
('ZNR', 'ZORRO NICOLAS ROMERO'),
('ZOZ', 'ZORRO OZUMBA '),
('ZPA', 'ZORRO PANTITLAN '),
('ZPI', 'ZORRO PICACHO'),
('ZPR', 'ZORRO PRIMAVERA'),
('ZQ6', 'ZORRO CENTRAL Q6 '),
('ZRH', 'ZORRO RIO HONDO'),
('ZRO', 'ZORRO ROLDAN'),
('ZSJ', 'ZORRO SAN JUANICO'),
('ZTC', 'ZORRO TECAMAC '),
('ZTH', 'ZORRO TLAHUAC '),
('ZTL', 'ZORRO TLANEPANTLA'),
('ZT1', 'ZORRO TOLUCA '),
('ZT2', 'ZORRO TOLUCA 2 '),
('ZTU', 'ZORRO TULANCINGO'),
('ZTX', 'ZORRO TEXCOCO'),
('ZTY', 'ZORRO TULYEHUALCO'),
('ZVC', 'ZORRO VALLE CHALCO '),
('ZVV', 'ZORRO VICENTE VILLADA '),
('ZTN', 'ZORRO TENAYUCA'),
('ZLN', 'ZORRO LEON'),
('ZQR', 'ZORRO QUERETARO'),
('ZIR', 'ZORRO IRAPUATO'),
('ZAR', 'ZORRO LAS ARMAS'),
('ZET', 'ZORRO ERMITA 2'),
('ZAN', 'ZORRO ATIZAPAN 2'),
('ZTT', 'ZORRO TULTITLAN'),
('ZE3', 'SORRO ECATEPEC 3'),
('ZIX', 'ZORRO IXTAPALUCA'),
('ZN2', 'ZORRO NICOLAS ROMERO 2'),
('ZAP', 'SUCURSAL AEROPUERTO'),
('ZFR', 'SAN FRANCISCO DEL RINCON'),
('ZCT', 'SUCURSAL CUAUTLA'),
('ZTZ', 'SUCURSAL TIZAYUCA'),
('ZSV', 'SUCURSAL SAN VICENTE '),
('ZPH', 'SUCURSAL PACHUCA'),
('ZQF', 'SUCURSAL FUENTES'),
('ZRS', 'SUCURSAL ROSARIO'),
('ZZU', 'SUCURSAL ZUMPANGO');


INSERT INTO prospects VALUES 
( 1, 'ZQF', 'Efren', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Efa', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Lalo', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Adeian', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Adelr', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Poac', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'hECTOR', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Victos', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Efrdew', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Efr21n', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono'),
( 1, 'ZQF', 'Master', 'Aldana', 'Escalona', 6731563842, '1900-01-01', 'No respondio el telefono','1900-01-02', 'No respondio el telefono','1900-01-03', 'No respondio el telefono');

INSERT INTO borrowers VALUES 
(1, 1234, '1900-01-01', 0, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(2, 1234, '1900-01-01', 1, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(3, 1234, '1900-01-01', 1, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(4, 1234, '1900-01-01', 1, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(5, 1234, '1900-01-01', 1, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(6, 1234, '1900-01-01', 0, 0, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(7, 1234, '1900-01-01', 0, 0, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(8, 1234, '1900-01-01', 0, 0, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(9, 1234, '1900-01-01', 1, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(10, 1234, '1900-01-01', 0, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311),
(11, 1234, '1900-01-01', 0, 1, 'cALLE OJO DE AGUA', 'mAESTRA1',123456, 'Master2', 654311);

INSERT INTO clientapplications VALUES
( 1, 12, 1, 0, 0, '1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Aprobado', 'Simple'),
( 2, 13, 2, 0, 0, '1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Rechazado', 'Simple'),
( 3, 14, 3, 0, 0, '1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'En proceso', 'Simple'),
( 4, 15, 4, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'En proceso', 'Simple'),
( 5, 16, 5, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'En proceso', 'Simple'),
( 6, 17, 6, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'En proceso', 'Simple'),
( 7, 18, 7, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Rechazado', 'Simple'),
( 8, 19, 8, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Rechazado', 'Simple'),
( 9, 20, 9, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Aprobado', 'Simple'),
( 10, 21, 10, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Aprobado', 'Simple'),
( 11, 22, 11, 0, 0,'1900-01-01', 5, 60000, 100000, 50000, '1900-01-01', 'Aprobado', 'Simple');