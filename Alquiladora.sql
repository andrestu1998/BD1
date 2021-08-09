USE YLP_TLC

CREATE TABLE Sucursal(
	idSucursal			NVARCHAR(4), --Forma de la id: xxxx (codigo de cada municipio)
	departamento		NVARCHAR(30) NOT NULL,
	ciudad				NVARCHAR(30) NOT NULL,
	direccion			NVARCHAR(100) NOT NULL,
	CONSTRAINT pk_sucursal PRIMARY KEY(idSucursal)
)

CREATE TABLE Usuario(
	idUsuario			NVARCHAR(11), --Forma de la id: xxxx-xxx-xx (indica la sucursal, puesto y numero de empleado)
	sucursal			NVARCHAR(4),
	nombre				NVARCHAR(10) NOT NULL,
	sdoNombre			NVARCHAR(10),
	apellido			NVARCHAR(10) NOT NULL,
	sdoApellido			NVARCHAR(10) NOT NULL,
	sexo				CHAR(1) CHECK (sexo IN ('M', 'F')) NOT NULL,
	id					NVARCHAR(15) NOT NULL,
	rtn					NVARCHAR(14) NOT NULL,
	correoInstitucional	NVARCHAR(50) CHECK (correoInstitucional LIKE ('%@%.%')) NOT NULL,
	correoPersonal		NVARCHAR(50) CHECK (correoPersonal LIKE ('%@%.%')),
	telefono			NVARCHAR(8) NOT NULL,
	direccionDomicilio	NVARCHAR(100) NOT NULL,
	CONSTRAINT pk_usuario PRIMARY KEY(idUsuario)
)

CREATE TABLE Rol(
	idRol				NVARCHAR(2),
	rol					NVARCHAR(50) NOT NULL,
	CONSTRAINT pk_rol PRIMARY KEY(idRol)
)

CREATE TABLE UsuarioRol(
	usuario				NVARCHAR(11),
	rol					NVARCHAR(2),
	CONSTRAINT fk_usuario FOREIGN KEY(usuario) REFERENCES Usuario(idUsuario),
	CONSTRAINT fk_rol FOREIGN KEY(rol) REFERENCES Rol(idRol)
)
--Datos necearios para alquilar un auto
CREATE TABLE Cliente(
	idCliente			NVARCHAR(12), --Forma de la id: xxxx-xxxxxxx (indica sucursal y numero de cliente)
	nombre				NVARCHAR(10) NOT NULL,
	apellido			NVARCHAR(10) NOT NULL,
	sexo				CHAR(1) CHECK(sexo IN ('M', 'F')) NOT NULL,
	id					NVARCHAR(15) NOT NULL,
	rtn					NVARCHAR(14),
	correo				NVARCHAR(50) CHECK (correo LIKE ('%@%.%')) NOT NULL,
	telefono			NVARCHAR(8) NOT NULL,
	direccionDomicilio	NVARCHAR(100) NOT NULL,
	CONSTRAINT pk_cliente PRIMARY KEY(idCliente)
)

CREATE TABLE Proveedor(
	idProveedor			NVARCHAR(4), -- Forma de la id: x-xx (indica tipo de seguro y orden de registro)
	nombre				NVARCHAR(50) NOT NULL,
	producto			NVARCHAR(20) CHECK (producto IN ('Seguro', 'Automovil')) NOT NULL,
	correo				NVARCHAR(50) CHECK (correo LIKE ('%@%.%')) NOT NULL,
	telefono			NVARCHAR(8) NOT NULL,
	direccion			NVARCHAR(100) NOT NULL,
	CONSTRAINT pk_proveedor PRIMARY KEY(idProveedor)
)

CREATE TABLE Automovil(
	idAutomovil			NVARCHAR(10), --Forma de la id: xxx-xxxxxx (indica tipo de auto y orden de registro)
	proveedor			NVARCHAR(4),
	tipoAuto			NVARCHAR(30) NOT NULL,
	marca				NVARCHAR(15) NOT NULL,
	modelo				NVARCHAR(20) NOT NULL,
	placa				NVARCHAR(10) NOT NULL,
	anio				NVARCHAR(4) NOT NULL,
	CONSTRAINT pk_automovil PRIMARY KEY(idAutomovil)
)

CREATE TABLE Seguro(
	idSeguro			NVARCHAR(6), --Forma de la id: xxx-xx (indica codigo especial y numero de seguro)
	proveedor			NVARCHAR(4),
	nombre				NVARCHAR(30) NOT NULL,
	tipoSeguro			NVARCHAR(30) NOT NULL,
	descripcion			NVARCHAR(500) NOT NULL,
	CONSTRAINT pk_seguro PRIMARY KEY(idSeguro)
)

CREATE TABLE Inventario(
	idInventario		NVARCHAR(8), --Forma de la id: xxxx-xxx (indica año de registro y numero de inventario)
	sucursal			NVARCHAR(4),
	automovil			NVARCHAR(10),
	añoAdquisicion		NVARCHAR(4) NOT NULL,
	estado				NVARCHAR(500) NOT NULL,
	disponibilidad		CHAR(1) NOT NULL,
	kilometraje			INTEGER NOT NULL,
	combustible			NVARCHAR(15),
	CONSTRAINT pk_inventario PRIMARY KEY(idInventario)
)

CREATE TABLE Servicio(
	idServicio			NVARCHAR(9), --Forma de la id: qqxx-xxxx (indica tipode servicio, año en el que se solicito y numero de servicio)
	tipoServicio		NVARCHAR(10) NOT NULL,
	fechaInicio			DATE NOT NULL,
	fechaFinal			DATE NOT NULL,
	CONSTRAINT pk_servicio PRIMARY KEY(idServicio)
)

CREATE TABLE DetallePago(
	idDetalle			NVARCHAR(9), --Forma de la id: qqxx-xxxx (indica tipode servicio, año en el que se solicito y numero de detalle)
	servicio			NVARCHAR(9),
	seguro				NVARCHAR(6),
	subtotal			FLOAT NOT NULL,
	isv					FLOAT NOT NULL,
	total				FLOAT NOT NULL,
	CONSTRAINT pk_detalle PRIMARY KEY(idDetalle)
)

CREATE TABLE Factura(
	idFactura			NVARCHAR(9), -- debe ser el mismo numero que detallepago
	sucursal			NVARCHAR(4),
	usuario				NVARCHAR(11),
	fecha				DATE,
	cliente				NVARCHAR(12),
	tipoPago			NVARCHAR(10) NOT NULL,
	detallePago			NVARCHAR(9),
	CONSTRAINT pk_factura PRIMARY KEY(idFactura)
)

ALTER TABLE Usuario
	ADD CONSTRAINT fk_sucursalU FOREIGN KEY (sucursal)
	REFERENCES Sucursal(idSucursal)

ALTER TABLE Automovil
	ADD CONSTRAINT fk_proveedorA FOREIGN KEY (proveedor)
	REFERENCES Proveedor(idProveedor)

ALTER TABLE Seguro
	ADD CONSTRAINT fk_proveedorS FOREIGN KEY (proveedor)
	REFERENCES Proveedor(idProveedor)

ALTER TABLE Inventario
	ADD CONSTRAINT fk_sucursalI FOREIGN KEY (sucursal)
	REFERENCES Sucursal(idSucursal)

ALTER TABLE Inventario
	ADD CONSTRAINT fk_automovilI FOREIGN KEY (automovil)
	REFERENCES Automovil(idAutomovil)

ALTER TABLE DetallePago
	ADD CONSTRAINT fk_servicioD FOREIGN KEY (servicio)
	REFERENCES Servicio(idServicio)

ALTER TABLE DetallePago
	ADD CONSTRAINT fk_seguroD FOREIGN KEY (seguro)
	REFERENCES Seguro(idSeguro)

ALTER TABLE Factura
	ADD CONSTRAINT fk_sucursalF FOREIGN KEY (sucursal)
	REFERENCES Sucursal(idSucursal)

ALTER TABLE Factura
	ADD CONSTRAINT fk_usuarioF FOREIGN KEY(usuario)
	REFERENCES Usuario(idUsuario)

ALTER TABLE Factura
	ADD CONSTRAINT fk_detalleF FOREIGN KEY (detallePago)
	REFERENCES DetallePago(idDetalle)

ALTER TABLE Factura
	ADD CONSTRAINT fk_clienteF FOREIGN KEY (cliente)
	REFERENCES Cliente(idCliente)

INSERT INTO Sucursal VALUES	('0801', 'Francisco Morazan', 'Tegucigalpa', 'por el edificio rojo')
INSERT INTO Sucursal VALUES	('0501', 'Cortés', 'San Pedro Sula', 'por el aeropuerto')
INSERT INTO Sucursal VALUES	('0506', 'Cortés', 'Puerto Cortés', 'dos cuadras despues del puerto')
INSERT INTO Sucursal VALUES	('0101', 'Atlantida', 'La Ceiba', 'a la par del hotel Palmira Real')
INSERT INTO Sucursal VALUES	('0401', 'Copán', 'Santa Rosa de Copán', 'oficinas dentro del hotel clarion')


INSERT INTO Usuario VALUES	('0801-GEG-01'	, '0801'	, 'JUAN'	, 'MIGUEL'	, 'ABDO'	, 'FRANCIS'	, 'M'	, '0801-1990-00001'	, '10000000000001'	, 'JUAN@alquiladora.com'	, 'ABDO@gmail.com'	, '10000001'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-CHO-01'	, '0801'	, 'LUIS'	, 'FELIPE'	, 'ABREU'	, 'HERNÁNDEZ'	, 'M'	, '0801-1990-00002'	, '10000000000002'	, 'LUIS@alquiladora.com'	, 'ABREU@gmail.com'	, '10000002'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ALQ-01'	, '0801'	, 'LAURA'	, 'SUSANA'	, 'ACOSTA'	, 'TORRES'	, 'F'	, '0801-1990-00003'	, '10000000000003'	, 'LAURA@alquiladora.com'	, 'ACOSTA@gmail.com'	, '10000003'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ALQ-02'	, '0801'	, 'ÁLVARO'	, NULL	, 'AGUAYO'	, 'GONZÁLEZ'	, 'M'	, '0801-1990-00004'	, '10000000000004'	, 'ÁLVARO@alquiladora.com'	, 'AGUAYO@gmail.com'	, '10000004'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ALQ-03'	, '0801'	, 'SARA'	, 'GLORIA'	, 'AGUILAR'	, 'NAVARRO'	, 'F'	, '0801-1990-00005'	, '10000000000005'	, 'SARA@alquiladora.com'	, 'AGUILAR@gmail.com'	, '10000005'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ALQ-04'	, '0801'	, 'CARLOS'	, 'ALBERTO'	, 'AGUILAR'	, 'SALINAS'	, 'M'	, '0801-1990-00006'	, '10000000000006'	, 'CARLOS@alquiladora.com'	, 'AGUILAR@gmail.com'	, '10000006'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ASE-01'	, '0801'	, 'JOSÉ'	, 'ÁLVARO'	, 'AGUILAR'	, 'SETIÉN'	, 'M'	, '0801-1990-00007'	, '10000000000007'	, 'JOSÉ@alquiladora.com'	, 'AGUILAR@gmail.com'	, '10000007'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ASE-02'	, '0801'	, 'MARÍA'	, 'LUCINDA'	, 'AGUIRRE'	, 'CRUZ'	, 'F'	, '0801-1990-00008'	, '10000000000008'	, 'MARÍA@alquiladora.com'	, 'AGUIRRE@gmail.com'	, '10000008'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ASE-03'	, '0801'	, 'JESÚS'	, NULL	, 'AGUIRRE'	, 'GARCÍA'	, 'M'	, '0801-1990-00009'	, '10000000000009'	, 'JESÚS@alquiladora.com'	, 'AGUIRRE@gmail.com'	, '10000009'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-ASE-04'	, '0801'	, 'HÉCTOR'	, 'GERARDO'	, 'AGUIRRE'	, 'GAS'	, 'M'	, '0801-1990-00010'	, '10000000000010'	, 'HÉCTOR@alquiladora.com'	, 'AGUIRRE@gmail.com'	, '10000010'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-CHO-02'	, '0801'	, 'JOSEFINA'	, 'MARÍA'	, 'ALBERÚ'	, 'GÓMEZ'	, 'F'	, '0801-1990-00011'	, '10000000000011'	, 'JOSEFINA@alquiladora.com'	, 'ALBERÚ@gmail.com'	, '10000011'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-CHO-03'	, '0801'	, 'MARÍA'	, 'DOLORES'	, 'ALCÁNTAR'	, 'CURIEL'	, 'F'	, '0801-1990-00012'	, '10000000000012'	, 'MARÍA@alquiladora.com'	, 'ALCÁNTAR@gmail.com'	, '10000012'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-CAJ-01'	, '0801'	, 'MANUEL'	, NULL	, 'ALCARAZ'	, 'VERDUZCO'	, 'M'	, '0801-1990-00013'	, '10000000000013'	, 'MANUEL@alquiladora.com'	, 'ALCARAZ@gmail.com'	, '10000013'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-CAJ-02'	, '0801'	, 'JORGE'	, NULL	, 'ALCOCER'	, 'VARELA'	, 'M'	, '0801-1990-00014'	, '10000000000014'	, 'JORGE@alquiladora.com'	, 'ALCOCER@gmail.com'	, '10000014'	, 'Col.: Cerro Grande')
INSERT INTO Usuario VALUES	('0801-CAJ-03'	, '0801'	, 'ERICK'	, NULL	, 'ALEXANDER'	, 'ROSAS'	, 'M'	, '0801-1990-00015'	, '10000000000015'	, 'ERICK@alquiladora.com'	, 'ALEXANDERSON@gmail.com'	, '10000015'	, 'Col.: Cerro Grande')

INSERT INTO Usuario VALUES	('0501-GES-01'	, '0501'	, 'PALOMA'	, NULL	, 'ALMEDA'	, 'VALDÉS'	, 'F'	, '0501-1990-00001'	, '10000000000016'	, 'PALOMA@alquiladora.com'	, 'ALMEDA@gmail.com'	, '10000016'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-CHO-01'	, '0501'	, 'MARIO'	, 'ARTURO'	, 'ALONSO'	, 'VANEGAS'	, 'M'	, '0501-1990-00002'	, '10000000000017'	, 'MARIO@alquiladora.com'	, 'ALONSO@gmail.com'	, '10000017'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ALQ-01'	, '0501'	, 'PATRICIA'	, NULL	, 'ALONSO'	, 'VIVEROS'	, 'F'	, '0501-1990-00003'	, '10000000000018'	, 'PATRICIA@alquiladora.com'	, 'ALONSO@gmail.com'	, '10000018'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ALQ-02'	, '0501'	, 'CELIA'	, 'MERCEDES'	, 'ALPUCHE'	, 'ARANDA'	, 'F'	, '0501-1990-00004'	, '10000000000019'	, 'CELIA@alquiladora.com'	, 'ALPUCHE@gmail.com'	, '10000019'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ALQ-03'	, '0501'	, 'CARLOS'	, 'ALFONSO'	, 'ALVA'	, 'ESPINOSA'	, 'M'	, '0501-1990-00005'	, '10000000000020'	, 'CARLOS@alquiladora.com'	, 'ALVA@gmail.com'	, '10000020'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ALQ-04'	, '0501'	, 'MARÍA'	, 'ISABEL'	, 'ALVARADO'	, 'CABRERO'	, 'F'	, '0501-1990-00006'	, '10000000000021'	, 'MARÍA@alquiladora.com'	, 'ALVARADO@gmail.com'	, '10000021'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ASE-01'	, '0501'	, 'RAFAEL'	, NULL	, 'ÁLVAREZ'	, 'CORDERO'	, 'M'	, '0501-1990-00007'	, '10000000000022'	, 'RAFAEL@alquiladora.com'	, 'ÁLVAREZ@gmail.com'	, '10000022'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ASE-02'	, '0501'	, 'MARÍA'	, 'ASUNCIÓN'	, 'ÁLVAREZ'	, 'DEL RÍO'	, 'F'	, '0501-1990-00008'	, '10000000000023'	, 'MARÍA@alquiladora.com'	, 'ÁLVAREZ@gmail.com'	, '10000023'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ASE-03'	, '0501'	, 'FRANCISCO'	, 'JAVIER'	, 'ÁLVAREZ'	, 'LEFFMANS'	, 'M'	, '0501-1990-00009'	, '10000000000024'	, 'FRANCISCO@alquiladora.com'	, 'ÁLVAREZ@gmail.com'	, '10000024'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-ASE-04'	, '0501'	, 'PABLO'	, NULL	, 'ÁLVAREZ'	, 'MALDONADO'	, 'M'	, '0501-1990-00010'	, '10000000000025'	, 'PABLO@alquiladora.com'	, 'ÁLVAREZ@gmail.com'	, '10000025'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-CHO-02'	, '0501'	, 'JOSÉ'	, NULL	, 'ÁLVAREZ'	, 'NEMEGYEI'	, 'M'	, '0501-1990-00011'	, '10000000000026'	, 'JOSÉ@alquiladora.com'	, 'ÁLVAREZ@gmail.com'	, '10000026'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-CHO-03'	, '0501'	, 'JOSÉ'	, 'DANTE'	, 'AMATO'	, 'MARTÍNEZ'	, 'M'	, '0501-1990-00012'	, '10000000000027'	, 'JOSÉ@alquiladora.com'	, 'AMATO@gmail.com'	, '10000027'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-CAJ-01'	, '0501'	, 'MARÍA'	, 'DEL'	, 'AMIGO'	, 'CASTAÑEDA'	, 'F'	, '0501-1990-00013'	, '10000000000028'	, 'MARÍA@alquiladora.com'	, 'AMIGO@gmail.com'	, '10000028'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-CAJ-02'	, '0501'	, 'ARTURO'	, NULL	, 'ÁNGELES'	, 'ÁNGELES'	, 'M'	, '0501-1990-00014'	, '10000000000029'	, 'ARTURO@alquiladora.com'	, 'ÁNGELES@gmail.com'	, '10000029'	, 'Col.:3 de mayo')
INSERT INTO Usuario VALUES	('0501-CAJ-03'	, '0501'	, ' ALBERTO'	, 'MANUEL'	, 'ÁNGELES'	, 'CASTILLA'	, 'M'	, '0501-1990-00015'	, '10000000000030'	, ' ALBERTO@alquiladora.com'	, 'ÁNGELES@gmail.com'	, '10000030'	, 'Col.:3 de mayo')

INSERT INTO Usuario VALUES	('0506-GES-01'	, '0506'	, 'ROGELIO'	, NULL	, 'APIQUIAN'	, 'GUITART'	, 'M'	, '0506-1990-00001'	, '10000000000031'	, 'ROGELIO@alquiladora.com'	, 'APIQUIAN@gmail.com'	, '10000031'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-CHO-01'	, '0506'	, 'JOAQUÍN'	, NULL	, 'ARAICO'	, 'LAGUILLO'	, 'M'	, '0506-1990-00002'	, '10000000000032'	, 'JOAQUÍN@alquiladora.com'	, 'ARAICO@gmail.com'	, '10000032'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ALQ-01'	, '0506'	, 'ÁNGEL'	, 'ANTONIO'	, 'ARAUZ'	, 'GÓNGORA'	, 'M'	, '0506-1990-00003'	, '10000000000033'	, 'ÁNGEL@alquiladora.com'	, 'ARAUZ@gmail.com'	, '10000033'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ALQ-02'	, '0506'	, 'HERIBERTO'	, NULL	, 'ARCILA'	, 'HERRERA'	, 'M'	, '0506-1990-00004'	, '10000000000034'	, 'HERIBERTO@alquiladora.com'	, 'ARCILA@gmail.com'	, '10000034'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ALQ-03'	, '0506'	, 'MARÍA'	, 'DE'	, 'ARELLANES'	, 'GARCÍA'	, 'F'	, '0506-1990-00005'	, '10000000000035'	, 'MARÍA@alquiladora.com'	, 'ARELLANES@gmail.com'	, '10000035'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ALQ-04'	, '0506'	, 'ROBERTO'	, NULL	, 'ARENAS'	, 'GUZMÁN'	, 'M'	, '0506-1990-00006'	, '10000000000036'	, 'ROBERTO@alquiladora.com'	, 'ARENAS@gmail.com'	, '10000036'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ASE-01'	, '0506'	, 'RUBÉN'	, NULL	, 'ARGÜERO'	, 'SÁNCHEZ'	, 'M'	, '0506-1990-00007'	, '10000000000037'	, 'RUBÉN@alquiladora.com'	, 'ARGÜERO@gmail.com'	, '10000037'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ASE-02'	, '0506'	, 'JOSÉ'	, 'ANTONIO'	, 'ARIAS'	, 'MONTAÑO'	, 'M'	, '0506-1990-00008'	, '10000000000038'	, 'JOSÉ@alquiladora.com'	, 'ARIAS@gmail.com'	, '10000038'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ASE-03'	, '0506'	, 'CUAUHTÉMOC'	, 'RAÚL'	, 'ARIZA'	, 'ANDRACA'	, 'M'	, '0506-1990-00009'	, '10000000000039'	, 'CUAUHTÉMOC@alquiladora.com'	, 'ARIZA@gmail.com'	, '10000039'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-ASE-04'	, '0506'	, 'JUAN'	, 'SOCORRO'	, 'ARMENDÁRIZ'	, 'BORUNDA'	, 'M'	, '0506-1990-00010'	, '10000000000040'	, 'JUAN@alquiladora.com'	, 'ARMENDÁRIZ@gmail.com'	, '10000040'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-CHO-02'	, '0506'	, 'JOSÉ'	, 'HUGO'	, 'ARREDONDO'	, 'GALÁN'	, 'M'	, '0506-1990-00011'	, '10000000000041'	, 'JOSÉ@alquiladora.com'	, 'ARREDONDO@gmail.com'	, '10000041'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-CHO-03'	, '0506'	, 'JAIME'	, 'JACOBO'	, 'ARRIAGA'	, 'GRACIA'	, 'M'	, '0506-1990-00012'	, '10000000000042'	, 'JAIME@alquiladora.com'	, 'ARRIAGA@gmail.com'	, '10000042'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-CAJ-01'	, '0506'	, 'LOURDES'	, 'ANDREA'	, 'ARRIAGA'	, 'PIZANO'	, 'F'	, '0506-1990-00013'	, '10000000000043'	, 'LOURDES@alquiladora.com'	, 'ARRIAGA@gmail.com'	, '10000043'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-CAJ-02'	, '0506'	, 'OSCAR'	, 'GERARDO'	, 'ARRIETA'	, 'RODRÍGUEZ'	, 'M'	, '0506-1990-00014'	, '10000000000044'	, 'OSCAR@alquiladora.com'	, 'ARRIETA@gmail.com'	, '10000044'	, 'Res.: El Sauce')
INSERT INTO Usuario VALUES	('0506-CAJ-03'	, '0506'	, 'PEDRO'	, NULL	, 'ARROYO'	, 'ACEVEDO'	, 'M'	, '0506-1990-00015'	, '10000000000045'	, 'PEDRO@alquiladora.com'	, 'ARROYO@gmail.com'	, '10000045'	, 'Res.: El Sauce')

INSERT INTO Usuario VALUES	('0101-GES-01'	, '0101'	, 'ANA'	, 'CRISTINA'	, 'ARTEAGA'	, 'GÓMEZ'	, 'F'	, '0101-1990-00001'	, '10000000000046'	, 'ANA@alquiladora.com'	, 'ARTEAGA@gmail.com'	, '10000046'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-CHO-01'	, '0101'	, 'HIGINIO'	, NULL	, 'ARZATE'	, 'ARZATE'	, 'M'	, '0101-1990-00002'	, '10000000000047'	, 'HIGINIO@alquiladora.com'	, 'ARZATE@gmail.com'	, '10000047'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ALQ-01'	, '0101'	, 'HUMBERTO'	, 'FRANCISCO'	, 'ASTIAZARÁN'	, 'GARCÍA'	, 'M'	, '0101-1990-00003'	, '10000000000048'	, 'HUMBERTO@alquiladora.com'	, 'ASTIAZARÁN@gmail.com'	, '10000048'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ALQ-02'	, '0101'	, 'ESPERANZA'	, 'DEL'	, 'ÁVALOS'	, 'DÍAZ'	, 'F'	, '0101-1990-00004'	, '10000000000049'	, 'ESPERANZA@alquiladora.com'	, 'ÁVALOS@gmail.com'	, '10000049'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ALQ-03'	, '0101'	, 'MARÍA'	, 'DEL'	, 'ÁVILA'	, 'CASADO'	, 'F'	, '0101-1990-00005'	, '10000000000050'	, 'MARÍA@alquiladora.com'	, 'ÁVILA@gmail.com'	, '10000050'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ALQ-04'	, '0101'	, 'JOSÉ'	, 'ALBERTO'	, 'ÁVILA'	, 'FUNES'	, 'M'	, '0101-1990-00006'	, '10000000000051'	, 'JOSÉ@alquiladora.com'	, 'ÁVILA@gmail.com'	, '10000051'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ASE-01'	, '0101'	, 'MIGUEL'	, 'ÁNGEL'	, 'ÁVILA'	, 'RODRÍGUEZ'	, 'M'	, '0101-1990-00007'	, '10000000000052'	, 'MIGUEL@alquiladora.com'	, 'ÁVILA@gmail.com'	, '10000052'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ASE-02'	, '0101'	, 'JORGE'	, 'ARTURO'	, 'AVIÑA'	, 'VALENCIA'	, 'M'	, '0101-1990-00008'	, '10000000000053'	, 'JORGE@alquiladora.com'	, 'AVIÑA@gmail.com'	, '10000053'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ASE-03'	, '0101'	, 'AQUILES'	, 'R.'	, 'AYALA'	, 'RUÍZ'	, 'M'	, '0101-1990-00009'	, '10000000000054'	, 'AQUILES@alquiladora.com'	, 'AYALA@gmail.com'	, '10000054'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-ASE-04'	, '0101'	, 'ALEJANDRA'	, 'RENATA'	, 'BÁEZ'	, 'SALDAÑA'	, 'F'	, '0101-1990-00010'	, '10000000000055'	, 'ALEJANDRA@alquiladora.com'	, 'BÁEZ@gmail.com'	, '10000055'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-CHO-02'	, '0101'	, 'MANUEL'	, 'ANTONIO'	, 'BAEZA'	, 'BACAB'	, 'M'	, '0101-1990-00011'	, '10000000000056'	, 'MANUEL@alquiladora.com'	, 'BAEZA@gmail.com'	, '10000056'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-CHO-03'	, '0101'	, 'CARLOS'	, NULL	, 'BAEZA'	, 'HERRERA'	, 'M'	, '0101-1990-00012'	, '10000000000057'	, 'CARLOS@alquiladora.com'	, 'BAEZA@gmail.com'	, '10000057'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-CAJ-01'	, '0101'	, 'HÉCTOR'	, 'ALFREDO'	, 'BAPTISTA'	, 'GONZÁLEZ'	, 'M'	, '0101-1990-00013'	, '10000000000058'	, 'HÉCTOR@alquiladora.com'	, 'BAPTISTA@gmail.com'	, '10000058'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-CAJ-02'	, '0101'	, 'FERNANDO'	, NULL	, 'BARINAGA'	, 'ALDATZ'	, 'M'	, '0101-1990-00014'	, '10000000000059'	, 'FERNANDO@alquiladora.com'	, 'BARINAGARREMENTERÍA@gmail.com'	, '10000059'	, ' El Hatillo')
INSERT INTO Usuario VALUES	('0101-CAJ-03'	, '0101'	, 'SIMÓN'	, NULL	, 'BARQUERA'	, 'CERVERA'	, 'M'	, '0101-1990-00015'	, '10000000000060'	, 'SIMÓN@alquiladora.com'	, 'BARQUERA@gmail.com'	, '10000060'	, ' El Hatillo')

INSERT INTO Usuario VALUES	('0401-GES-01'	, '0401'	, 'RODOLFO'	, NULL	, 'BARRAGÁN'	, 'GARCÍA'	, 'M'	, '0401-1990-00001'	, '10000000000061'	, 'RODOLFO@alquiladora.com'	, 'BARRAGÁN@gmail.com'	, '10000061'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-CHO-01'	, '0401'	, 'JOSÉ'	, 'LUIS'	, 'BARRERA'	, 'FRANCO'	, 'M'	, '0401-1990-00002'	, '10000000000062'	, 'JOSÉ@alquiladora.com'	, 'BARRERA@gmail.com'	, '10000062'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ALQ-01'	, '0401'	, 'HUGO'	, 'ALBERTO'	, 'BARRERA'	, 'SALDAÑA'	, 'M'	, '0401-1990-00003'	, '10000000000063'	, 'HUGO@alquiladora.com'	, 'BARRERA@gmail.com'	, '10000063'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ALQ-02'	, '0401'	, 'TONATIUH'	, NULL	, 'BARRIENTOS'	, 'GUTIÉRREZ'	, 'M'	, '0401-1990-00004'	, '10000000000064'	, 'TONATIUH@alquiladora.com'	, 'BARRIENTOS@gmail.com'	, '10000064'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ALQ-03'	, '0401'	, 'JORGE'	, 'ARMANDO'	, 'BARRIGUETE'	, 'MELÉNDEZ'	, 'M'	, '0401-1990-00005'	, '10000000000065'	, 'JORGE@alquiladora.com'	, 'BARRIGUETE@gmail.com'	, '10000065'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ALQ-04'	, '0401'	, 'JUAN'	, 'GERARDO'	, 'BARROSO'	, 'VILLA'	, 'M'	, '0401-1990-00006'	, '10000000000066'	, 'JUAN@alquiladora.com'	, 'BARROSO@gmail.com'	, '10000066'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ASE-01'	, '0401'	, 'MARÍA'	, 'DE'	, 'BASURTO'	, 'ACEVEDO'	, 'F'	, '0401-1990-00007'	, '10000000000067'	, 'MARÍA@alquiladora.com'	, 'BASURTO@gmail.com'	, '10000067'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ASE-02'	, '0401'	, 'INGEBORG'	, 'DOROTHEA'	, 'BECKER'	, 'FAUSER'	, 'F'	, '0401-1990-00008'	, '10000000000068'	, 'INGEBORG@alquiladora.com'	, 'BECKER@gmail.com'	, '10000068'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ASE-03'	, '0401'	, 'MARTÍN'	, NULL	, 'BEDOLLA'	, 'BARAJAS'	, 'M'	, '0401-1990-00009'	, '10000000000069'	, 'MARTÍN@alquiladora.com'	, 'BEDOLLA@gmail.com'	, '10000069'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-ASE-04'	, '0401'	, 'ARTURO'	, NULL	, 'BELTRÁN'	, 'ORTEGA'	, 'M'	, '0401-1990-00010'	, '10000000000070'	, 'ARTURO@alquiladora.com'	, 'BELTRÁN@gmail.com'	, '10000070'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-CHO-02'	, '0401'	, 'CARLOS'	, 'HERNÁN'	, 'BERLANGA'	, 'CISNEROS'	, 'M'	, '0401-1990-00011'	, '10000000000071'	, 'CARLOS@alquiladora.com'	, 'BERLANGA@gmail.com'	, '10000071'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-CHO-03'	, '0401'	, 'JOSÉ'	, 'ARTURO'	, 'BERMUDEZ'	, 'LLANOS'	, 'M'	, '0401-1990-00012'	, '10000000000072'	, 'JOSÉ@alquiladora.com'	, 'BERMUDEZ GÓMEZ@gmail.com'	, '10000072'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-CAJ-01'	, '0401'	, 'JOSÉ'	, 'MANUEL'	, 'BERRUECOS'	, 'VILLALOBOS'	, 'M'	, '0401-1990-00013'	, '10000000000073'	, 'JOSÉ@alquiladora.com'	, 'BERRUECOS@gmail.com'	, '10000073'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-CAJ-02'	, '0401'	, 'JAIME'	, NULL	, 'BERUMEN'	, 'CAMPOS'	, 'M'	, '0401-1990-00014'	, '10000000000074'	, 'JAIME@alquiladora.com'	, 'BERUMEN@gmail.com'	, '10000074'	, 'Copán Ruinas')
INSERT INTO Usuario VALUES	('0401-CAJ-03'	, '0401'	, 'FRANCISCO'	, NULL	, 'BIAGI'	, 'FILIZOLA'	, 'M'	, '0401-1990-00015'	, '10000000000075'	, 'FRANCISCO@alquiladora.com'	, 'BIAGI@gmail.com'	, '10000075'	, 'Copán Ruinas')


INSERT INTO Rol VALUES	('01'	, 'Gerente General')
INSERT INTO Rol VALUES	('02'	, 'Gerente de Sucursal')
INSERT INTO Rol VALUES	('03'	, 'Alquilador')
INSERT INTO Rol VALUES	('04'	, 'Chofer')
INSERT INTO Rol VALUES	('05'	, 'Cajero')
INSERT INTO Rol VALUES	('06'	, 'Aseador')


INSERT INTO UsuarioRol VALUES	('0801-GEG-01'	, '01')
INSERT INTO UsuarioRol VALUES	('0801-CHO-01'	, '04')
INSERT INTO UsuarioRol VALUES	('0801-ALQ-01'	, '03')
INSERT INTO UsuarioRol VALUES	('0801-ALQ-02'	, '03')
INSERT INTO UsuarioRol VALUES	('0801-ALQ-03'	, '03')
INSERT INTO UsuarioRol VALUES	('0801-ALQ-04'	, '03')
INSERT INTO UsuarioRol VALUES	('0801-ASE-01'	, '06')
INSERT INTO UsuarioRol VALUES	('0801-ASE-02'	, '06')
INSERT INTO UsuarioRol VALUES	('0801-ASE-03'	, '06')
INSERT INTO UsuarioRol VALUES	('0801-ASE-04'	, '06')
INSERT INTO UsuarioRol VALUES	('0801-CHO-02'	, '04')
INSERT INTO UsuarioRol VALUES	('0801-CHO-03'	, '04')
INSERT INTO UsuarioRol VALUES	('0801-CAJ-01'	, '05')
INSERT INTO UsuarioRol VALUES	('0801-CAJ-02'	, '05')
INSERT INTO UsuarioRol VALUES	('0801-CAJ-03'	, '05')
INSERT INTO UsuarioRol VALUES	('0501-GES-01'	, '02')
INSERT INTO UsuarioRol VALUES	('0501-CHO-01'	, '04')
INSERT INTO UsuarioRol VALUES	('0501-ALQ-01'	, '03')
INSERT INTO UsuarioRol VALUES	('0501-ALQ-02'	, '03')
INSERT INTO UsuarioRol VALUES	('0501-ALQ-03'	, '03')
INSERT INTO UsuarioRol VALUES	('0501-ALQ-04'	, '03')
INSERT INTO UsuarioRol VALUES	('0501-ASE-01'	, '06')
INSERT INTO UsuarioRol VALUES	('0501-ASE-02'	, '06')
INSERT INTO UsuarioRol VALUES	('0501-ASE-03'	, '06')
INSERT INTO UsuarioRol VALUES	('0501-ASE-04'	, '06')
INSERT INTO UsuarioRol VALUES	('0501-CHO-02'	, '04')
INSERT INTO UsuarioRol VALUES	('0501-CHO-03'	, '04')
INSERT INTO UsuarioRol VALUES	('0501-CAJ-01'	, '05')
INSERT INTO UsuarioRol VALUES	('0501-CAJ-02'	, '05')
INSERT INTO UsuarioRol VALUES	('0501-CAJ-03'	, '05')
INSERT INTO UsuarioRol VALUES	('0506-GES-01'	, '02')
INSERT INTO UsuarioRol VALUES	('0506-CHO-01'	, '04')
INSERT INTO UsuarioRol VALUES	('0506-ALQ-01'	, '03')
INSERT INTO UsuarioRol VALUES	('0506-ALQ-02'	, '03')
INSERT INTO UsuarioRol VALUES	('0506-ALQ-03'	, '03')
INSERT INTO UsuarioRol VALUES	('0506-ALQ-04'	, '03')
INSERT INTO UsuarioRol VALUES	('0506-ASE-01'	, '06')
INSERT INTO UsuarioRol VALUES	('0506-ASE-02'	, '06')
INSERT INTO UsuarioRol VALUES	('0506-ASE-03'	, '06')
INSERT INTO UsuarioRol VALUES	('0506-ASE-04'	, '06')
INSERT INTO UsuarioRol VALUES	('0506-CHO-02'	, '04')
INSERT INTO UsuarioRol VALUES	('0506-CHO-03'	, '04')
INSERT INTO UsuarioRol VALUES	('0506-CAJ-01'	, '05')
INSERT INTO UsuarioRol VALUES	('0506-CAJ-02'	, '05')
INSERT INTO UsuarioRol VALUES	('0506-CAJ-03'	, '05')
INSERT INTO UsuarioRol VALUES	('0101-GES-01'	, '02')
INSERT INTO UsuarioRol VALUES	('0101-CHO-01'	, '04')
INSERT INTO UsuarioRol VALUES	('0101-ALQ-01'	, '03')
INSERT INTO UsuarioRol VALUES	('0101-ALQ-02'	, '03')
INSERT INTO UsuarioRol VALUES	('0101-ALQ-03'	, '03')
INSERT INTO UsuarioRol VALUES	('0101-ALQ-04'	, '03')
INSERT INTO UsuarioRol VALUES	('0101-ASE-01'	, '06')
INSERT INTO UsuarioRol VALUES	('0101-ASE-02'	, '06')
INSERT INTO UsuarioRol VALUES	('0101-ASE-03'	, '06')
INSERT INTO UsuarioRol VALUES	('0101-ASE-04'	, '06')
INSERT INTO UsuarioRol VALUES	('0101-CHO-02'	, '04')
INSERT INTO UsuarioRol VALUES	('0101-CHO-03'	, '04')
INSERT INTO UsuarioRol VALUES	('0101-CAJ-01'	, '05')
INSERT INTO UsuarioRol VALUES	('0101-CAJ-02'	, '05')
INSERT INTO UsuarioRol VALUES	('0101-CAJ-03'	, '05')
INSERT INTO UsuarioRol VALUES	('0401-GES-01'	, '02')
INSERT INTO UsuarioRol VALUES	('0401-CHO-01'	, '04')
INSERT INTO UsuarioRol VALUES	('0401-ALQ-01'	, '03')
INSERT INTO UsuarioRol VALUES	('0401-ALQ-02'	, '03')
INSERT INTO UsuarioRol VALUES	('0401-ALQ-03'	, '03')
INSERT INTO UsuarioRol VALUES	('0401-ALQ-04'	, '03')
INSERT INTO UsuarioRol VALUES	('0401-ASE-01'	, '06')
INSERT INTO UsuarioRol VALUES	('0401-ASE-02'	, '06')
INSERT INTO UsuarioRol VALUES	('0401-ASE-03'	, '06')
INSERT INTO UsuarioRol VALUES	('0401-ASE-04'	, '06')
INSERT INTO UsuarioRol VALUES	('0401-CHO-02'	, '04')
INSERT INTO UsuarioRol VALUES	('0401-CHO-03'	, '04')
INSERT INTO UsuarioRol VALUES	('0401-CAJ-01'	, '05')
INSERT INTO UsuarioRol VALUES	('0401-CAJ-02'	, '05')
INSERT INTO UsuarioRol VALUES	('0401-CAJ-03'	, '05')


INSERT INTO Cliente VALUES	('0801-0000001',	'FRANCISCO',	'BLANCO',	'M',	'0801-1980-00001',	'10000000000076',	'FRANCISCO.BLANCO@outlook.es',	'10000076',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000002',	'NORMA',	'BOBADILLA',	'F',	'0801-1980-00002',	'10000000000077',	'NORMA.BOBADILLA@outlook.es',	'10000077',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000003',	'RAFAEL',	'BOJALIL',	'M',	'0801-1980-00003',	'10000000000078',	'RAFAEL.BOJALIL@outlook.es',	'10000078',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000004',	'ÁLVARO',	'BOLIO',	'M',	'0801-1980-00004',	'10000000000079',	'ÁLVARO.BOLIO@outlook.es',	'10000079',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000005',	'ANABELLE',	'BONVECCHIO',	'F',	'0801-1980-00005',	'10000000000080',	'ANABELLE.BONVECCHIO@outlook.es',	'10000080',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000006',	'VICTOR',	'BORJA',	'M',	'0801-1980-00006',	'10000000000081',	'VICTOR.BORJA@outlook.es',	'10000081',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000007',	'GABRIELA',	'BORRAYO',	'F',	'0801-1980-00007',	'10000000000082',	'GABRIELA.BORRAYO@outlook.es',	'10000082',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0801-0000008',	'FRANCISCO',	'BOSQUES',	'M',	'0801-1980-00008',	'10000000000083',	'FRANCISCO.BOSQUES@outlook.es',	'10000083',	'Barrio Abajo')
INSERT INTO Cliente VALUES	('0501-0000001',	'HÉCTOR',	'BOURGES',	'M',	'0501-1980-00009',	'10000000000084',	'HÉCTOR.BOURGES@outlook.es',	'10000084',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000002',	'EDUARDO',	'BRACHO',	'M',	'0501-1980-00010',	'10000000000085',	'EDUARDO.BRACHO@outlook.es',	'10000085',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000003',	'JESÚS',	'BRIONES',	'M',	'0501-1980-00011',	'10000000000086',	'JESÚS.BRIONES@outlook.es',	'10000086',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000004',	'ALFONSO',	'BUENDÍA',	'M',	'0501-1980-00012',	'10000000000087',	'ALFONSO.BUENDÍA@outlook.es',	'10000087',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000005',	'RUBÉN',	'BURGOS',	'M',	'0501-1980-00013',	'10000000000088',	'RUBÉN.BURGOS@outlook.es',	'10000088',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000006',	'ANTONIO',	'CABRAL',	'M',	'0501-1980-00014',	'10000000000089',	'ANTONIO.CABRAL@outlook.es',	'10000089',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000007',	'JUAN',	'CALDERÓN',	'M',	'0501-1980-00015',	'10000000000090',	'JUAN.CALDERÓN@outlook.es',	'10000090',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0501-0000008',	'ANA',	'CALDERÓN',	'F',	'0501-1980-00016',	'10000000000091',	'ANA.CALDERÓN@outlook.es',	'10000091',	'Villa Nueva')
INSERT INTO Cliente VALUES	('0506-0000001',	'JUAN',	'CALLEJA',	'M',	'0506-1980-00017',	'10000000000092',	'JUAN.CALLEJA@outlook.es',	'10000092',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000002',	'JUAN',	'CALVA',	'M',	'0506-1980-00018',	'10000000000093',	'JUAN.CALVA@outlook.es',	'10000093',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000003',	'ROBERTO',	'CALVA',	'M',	'0506-1980-00019',	'10000000000094',	'ROBERTO.CALVA@outlook.es',	'10000094',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000004',	'IGNACIO',	'CAMACHO',	'M',	'0506-1980-00020',	'10000000000095',	'IGNACIO.CAMACHO@outlook.es',	'10000095',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000005',	'ADRIÁN',	'CAMACHO',	'M',	'0506-1980-00021',	'10000000000096',	'ADRIÁN.CAMACHO@outlook.es',	'10000096',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000006',	'CARLOS',	'CAMPILLO',	'M',	'0506-1980-00022',	'10000000000097',	'CARLOS.CAMPILLO@outlook.es',	'10000097',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000007',	'ROBERTO',	'CAMPOS',	'M',	'0506-1980-00023',	'10000000000098',	'ROBERTO.CAMPOS@outlook.es',	'10000098',	'El Hato')
INSERT INTO Cliente VALUES	('0506-0000008',	'MANUEL',	'CAMPUZANO',	'M',	'0506-1980-00024',	'10000000000099',	'MANUEL.CAMPUZANO@outlook.es',	'10000099',	'El Hato')
INSERT INTO Cliente VALUES	('0101-0000001',	'FERNANDO',	'CANO',	'M',	'0101-1980-00025',	'10000000000100',	'FERNANDO.CANO@outlook.es',	'10000100',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000002',	'THELMA',	'CANTO',	'F',	'0101-1980-00026',	'10000000000101',	'THELMA.CANTO@outlook.es',	'10000101',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000003',	'CARLOS',	'CANTÚ',	'M',	'0101-1980-00027',	'10000000000102',	'CARLOS.CANTÚ@outlook.es',	'10000102',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000004',	'DAVID',	'CANTÚ',	'M',	'0101-1980-00028',	'10000000000103',	'DAVID.CANTÚ@outlook.es',	'10000103',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000005',	'ALFONSO',	'CARABEZ',	'M',	'0101-1980-00029',	'10000000000104',	'ALFONSO.CARABEZ@outlook.es',	'10000104',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000006',	'MARIO',	'CARDIEL',	'M',	'0101-1980-00030',	'10000000000105',	'MARIO.CARDIEL@outlook.es',	'10000105',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000007',	'JORGE',	'CARDONA',	'M',	'0101-1980-00031',	'10000000000106',	'JORGE.CARDONA@outlook.es',	'10000106',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0101-0000008',	'GUILLERMO',	'CAREAGA',	'M',	'0101-1980-00032',	'10000000000107',	'GUILLERMO.CAREAGA@outlook.es',	'10000107',	'Lomas de Toncontin')
INSERT INTO Cliente VALUES	('0401-0000001',	'ALESSANDRA',	'CARNEVALE',	'F',	'0401-1980-00033',	'10000000000108',	'ALESSANDRA.CARNEVALE@outlook.es',	'10000108',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000002',	'SEBASTIÁN',	'CARRANZA',	'M',	'0401-1980-00034',	'10000000000109',	'SEBASTIÁN.CARRANZA@outlook.es',	'10000109',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000003',	'RAÚL',	'CARRILLO',	'M',	'0401-1980-00035',	'10000000000110',	'RAÚL.CARRILLO@outlook.es',	'10000110',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000004',	'JOSÉ',	'CARRILLO',	'M',	'0401-1980-00036',	'10000000000111',	'JOSÉ.CARRILLO@outlook.es',	'10000111',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000005',	'VÍCTOR',	'CASTAÑO',	'M',	'0401-1980-00037',	'10000000000112',	'VÍCTOR.CASTAÑO@outlook.es',	'10000112',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000006',	'JORGE',	'CASTAÑÓN',	'M',	'0401-1980-00038',	'10000000000113',	'JORGE.CASTAÑÓN@outlook.es',	'10000113',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000007',	'GASTÓN',	'CASTILLA',	'M',	'0401-1980-00039',	'10000000000114',	'GASTÓN.CASTELLANOS@outlook.es',	'10000114',	'La Laguna')
INSERT INTO Cliente VALUES	('0401-0000008',	'LILIA',	'CASTILLO',	'F',	'0401-1980-00040',	'10000000000115',	'LILIA.CASTILLO@outlook.es',	'10000115',	'La Laguna')


INSERT INTO Proveedor VALUES	('A-01',	'Mazda',	'Automovil',	'mazda@automovil.com',	'10000116',	'anillo periferico')
INSERT INTO Proveedor VALUES	('A-02',	'Toyota',	'Automovil',	'toyota@automovil.com',	'10000117',	'anillo periferico')
INSERT INTO Proveedor VALUES	('A-03',	'Mitsubishi',	'Automovil',	'mitsubishi@automovil.com',	'10000118',	'anillo periferico')
INSERT INTO Proveedor VALUES	('A-04',	'Honda',	'Automovil',	'honda@automovil.com',	'10000119',	'anillo periferico')
INSERT INTO Proveedor VALUES	('S-01',	'Ficohsa Seguros',	'Seguro',	'ficohsa.seguros@seguro.com',	'10000120',	'anillo periferico')
INSERT INTO Proveedor VALUES	('S-02',	'Mapfre',	'Seguro',	'mapfre@seguro.com',	'10000121',	'anillo periferico')
INSERT INTO Proveedor VALUES	('S-03',	'Seguros Crefisa',	'Seguro',	'seguros.crefisa@crefis.com',	'10000122',	'anillo periferico')
INSERT INTO Proveedor VALUES	('S-04',	'Seguros del País',	'Seguro',	'seguros.del.país@seguro.com',	'10000123',	'anillo periferico')


INSERT INTO Automovil VALUES	('TUR-000001',	'A-01',	'Turismo',	'Mazda',	'Mazda 2',	'HQAA-0001',	'2021')
INSERT INTO Automovil VALUES	('TUR-000002',	'A-01',	'Turismo',	'Mazda',	'Mazda 3',	'HQAA-0002',	'2020')
INSERT INTO Automovil VALUES	('TUR-000003',	'A-01',	'Turismo',	'Mazda',	'Mazda 3',	'HQAA-0003',	'2019')
INSERT INTO Automovil VALUES	('TUR-000004',	'A-01',	'Turismo',	'Mazda',	'Sedán',	'HQAA-0004',	'2018')
INSERT INTO Automovil VALUES	('TUR-000005',	'A-01',	'Turismo',	'Mazda',	'Sedán',	'HQAA-0005',	'2017')
INSERT INTO Automovil VALUES	('CAM-000001',	'A-01',	'Camioneta',	'Mazda',	'BT-50',	'HQAA-0006',	'2016')
INSERT INTO Automovil VALUES	('CAM-000002',	'A-01',	'Camioneta',	'Mazda',	'Wagon',	'HQAA-0007',	'2015')
INSERT INTO Automovil VALUES	('CAM-000003',	'A-01',	'Camioneta',	'Mazda',	'CX-3',	'HQAA-0008',	'2016')
INSERT INTO Automovil VALUES	('CAM-000004',	'A-01',	'Camioneta',	'Mazda',	'CX-5',	'HQAA-0009',	'2017')
INSERT INTO Automovil VALUES	('CAM-000005',	'A-01',	'Camioneta',	'Mazda',	'CX-5',	'HQAA-0010',	'2018')
INSERT INTO Automovil VALUES	('TUR-000006',	'A-02',	'Turismo',	'Toyota',	'Corolla',	'HQAA-0011',	'2021')
INSERT INTO Automovil VALUES	('TUR-000007',	'A-02',	'Turismo',	'Toyota',	'Yaris',	'HQAA-0012',	'2020')
INSERT INTO Automovil VALUES	('TUR-000008',	'A-02',	'Turismo',	'Toyota',	'Prius',	'HQAA-0013',	'2019')
INSERT INTO Automovil VALUES	('CAM-000006',	'A-02',	'Camioneta',	'Toyota',	'Rav-4',	'HQAA-0014',	'2018')
INSERT INTO Automovil VALUES	('CAM-000007',	'A-02',	'Camioneta',	'Toyota',	'Hilux',	'HQAA-0015',	'2017')
INSERT INTO Automovil VALUES	('CAM-000008',	'A-02',	'Camioneta',	'Toyota',	'Prado',	'HQAA-0016',	'2016')
INSERT INTO Automovil VALUES	('PES-000001',	'A-02',	'Pesado',	'Toyota',	'Dyna',	'HQAA-0017',	'2015')
INSERT INTO Automovil VALUES	('CAM-000015',	'A-02',	'Camioneta',	'Toyota',	'SW4',	'HQAA-0018',	'2016')
INSERT INTO Automovil VALUES	('CAM-000016',	'A-02',	'Camioneta',	'Toyota',	'Hiace Wagon',	'HQAA-0019',	'2017')
INSERT INTO Automovil VALUES	('CAM-000017',	'A-02',	'Camioneta',	'Toyota',	'Corolla Cross',	'HQAA-0020',	'2018')
INSERT INTO Automovil VALUES	('TUR-000009',	'A-03',	'Turismo',	'Mitsubishi',	'i-MIEV',	'HQAA-0021',	'2021')
INSERT INTO Automovil VALUES	('TUR-000010',	'A-03',	'Turismo',	'Mitsubishi',	'Space Star',	'HQAA-0022',	'2020')
INSERT INTO Automovil VALUES	('TUR-000011',	'A-03',	'Turismo',	'Mitsubishi',	'Space Star',	'HQAA-0023',	'2019')
INSERT INTO Automovil VALUES	('CAM-000009',	'A-03',	'Camioneta',	'Mitsubishi',	'Eclipse Cross',	'HQAA-0024',	'2018')
INSERT INTO Automovil VALUES	('CAM-000010',	'A-03',	'Camioneta',	'Mitsubishi',	'L200',	'HQAA-0025',	'2017')
INSERT INTO Automovil VALUES	('CAM-000011',	'A-03',	'Camioneta',	'Mitsubishi',	'Montero',	'HQAA-0026',	'2016')
INSERT INTO Automovil VALUES	('CAM-000018',	'A-03',	'Camioneta',	'Mitsubishi',	'Outlander',	'HQAA-0027',	'2015')
INSERT INTO Automovil VALUES	('CAM-000019',	'A-03',	'Camioneta',	'Mitsubishi',	'L200',	'HQAA-0028',	'2016')
INSERT INTO Automovil VALUES	('CAM-000020',	'A-03',	'Camioneta',	'Mitsubishi',	'ASX',	'HQAA-0029',	'2017')
INSERT INTO Automovil VALUES	('CAM-000021',	'A-03',	'Camioneta',	'Mitsubishi',	'ASX',	'HQAA-0030',	'2018')
INSERT INTO Automovil VALUES	('TUR-000012',	'A-04',	'Turismo',	'Honda',	'Civic',	'HQAA-0031',	'2021')
INSERT INTO Automovil VALUES	('TUR-000013',	'A-04',	'Turismo',	'Honda',	'Accord',	'HQAA-0032',	'2020')
INSERT INTO Automovil VALUES	('TUR-000014',	'A-04',	'Turismo',	'Honda',	'Fit',	'HQAA-0033',	'2019')
INSERT INTO Automovil VALUES	('CAM-000012',	'A-04',	'Camioneta',	'Honda',	'CRV',	'HQAA-0034',	'2018')
INSERT INTO Automovil VALUES	('CAM-000013',	'A-04',	'Camioneta',	'Honda',	'HRV',	'HQAA-0035',	'2017')
INSERT INTO Automovil VALUES	('CAM-000014',	'A-04',	'Camioneta',	'Honda',	'Ridgeline',	'HQAA-0036',	'2016')
INSERT INTO Automovil VALUES	('TUR-000015',	'A-04',	'Turismo',	'Honda',	'Clarity',	'HQAA-0037',	'2015')
INSERT INTO Automovil VALUES	('TUR-000016',	'A-04',	'Turismo',	'Honda',	'Jazz',	'HQAA-0038',	'2016')
INSERT INTO Automovil VALUES	('CAM-000022',	'A-04',	'Camioneta',	'Honda',	'Odyssey',	'HQAA-0039',	'2017')
INSERT INTO Automovil VALUES	('CAM-000023',	'A-04',	'Camioneta',	'Honda',	'CRV',	'HQAA-0040',	'2018')


INSERT INTO Seguro VALUES	('MKT-01',	'S-01',	'Cobertura por Responsabilidad',	'Cobertura por Responsabilidad',	'HESOIAM')
INSERT INTO Seguro VALUES	('MKT-02',	'S-02',	'Cobertura Limitada.',	'Cobertura Limitada.',	'HESOIAM')
INSERT INTO Seguro VALUES	('MKT-03',	'S-03',	'Cobertura Amplia.',	'Cobertura Amplia.',	'HESOIAM')
INSERT INTO Seguro VALUES	('MKT-04',	'S-04',	'Cobertura Plus o Amplia Plus.',	'Cobertura Plus o Amplia Plus.',	'HESOIAM')


INSERT INTO Inventario VALUES	('2021-001',	'0801',	'TUR-000001',	'2021',	'casi nuevo',	'T',	'10000',	'lleno')
INSERT INTO Inventario VALUES	('2021-002',	'0801',	'TUR-000002',	'2020',	'casi nuevo',	'T',	'5000',	'vacio')
INSERT INTO Inventario VALUES	('2019-001',	'0801',	'TUR-000003',	'2019',	'usado',	'T',	'90000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-002',	'0801',	'TUR-000004',	'2019',	'usado',	'T',	'15000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-003',	'0801',	'TUR-000005',	'2019',	'usado',	'T',	'30000',	'casi vacio')
INSERT INTO Inventario VALUES	('2019-004',	'0801',	'CAM-000001',	'2019',	'usado',	'T',	'99999',	'lleno')
INSERT INTO Inventario VALUES	('2019-005',	'0801',	'CAM-000002',	'2019',	'usado',	'T',	'87000',	'vacio')
INSERT INTO Inventario VALUES	('2019-006',	'0801',	'CAM-000003',	'2019',	'usado',	'T',	'100000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-007',	'0501',	'CAM-000004',	'2019',	'usado',	'T',	'10000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-008',	'0501',	'CAM-000005',	'2019',	'usado',	'T',	'5000',	'casi vacio')
INSERT INTO Inventario VALUES	('2021-007',	'0501',	'TUR-000006',	'2021',	'casi nuevo',	'T',	'90000',	'lleno')
INSERT INTO Inventario VALUES	('2021-008',	'0501',	'TUR-000007',	'2020',	'casi nuevo',	'T',	'15000',	'vacio')
INSERT INTO Inventario VALUES	('2019-009',	'0501',	'TUR-000008',	'2019',	'usado',	'T',	'30000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-010',	'0501',	'CAM-000006',	'2019',	'usado',	'T',	'99999',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-011',	'0501',	'CAM-000007',	'2019',	'usado',	'T',	'87000',	'casi vacio')
INSERT INTO Inventario VALUES	('2019-012',	'0501',	'CAM-000008',	'2019',	'usado',	'T',	'100000',	'lleno')
INSERT INTO Inventario VALUES	('2019-013',	'0506',	'PES-000001',	'2019',	'usado',	'T',	'10000',	'vacio')
INSERT INTO Inventario VALUES	('2019-014',	'0506',	'CAM-000015',	'2019',	'usado',	'T',	'5000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-015',	'0506',	'CAM-000016',	'2019',	'usado',	'T',	'90000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-016',	'0506',	'CAM-000017',	'2019',	'usado',	'T',	'15000',	'casi vacio')
INSERT INTO Inventario VALUES	('2021-003',	'0506',	'TUR-000009',	'2021',	'casi nuevo',	'T',	'30000',	'lleno')
INSERT INTO Inventario VALUES	('2021-004',	'0506',	'TUR-000010',	'2020',	'casi nuevo',	'T',	'99999',	'vacio')
INSERT INTO Inventario VALUES	('2019-017',	'0506',	'TUR-000011',	'2019',	'usado',	'T',	'87000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-018',	'0506',	'CAM-000009',	'2019',	'usado',	'T',	'100000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-019',	'0101',	'CAM-000010',	'2019',	'usado',	'T',	'10000',	'casi vacio')
INSERT INTO Inventario VALUES	('2019-020',	'0101',	'CAM-000011',	'2019',	'usado',	'T',	'5000',	'lleno')
INSERT INTO Inventario VALUES	('2019-021',	'0101',	'CAM-000018',	'2019',	'usado',	'T',	'90000',	'vacio')
INSERT INTO Inventario VALUES	('2019-022',	'0101',	'CAM-000019',	'2019',	'usado',	'T',	'15000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-023',	'0101',	'CAM-000020',	'2019',	'usado',	'T',	'30000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-024',	'0101',	'CAM-000021',	'2019',	'usado',	'T',	'99999',	'casi vacio')
INSERT INTO Inventario VALUES	('2021-005',	'0101',	'TUR-000012',	'2021',	'casi nuevo',	'T',	'87000',	'lleno')
INSERT INTO Inventario VALUES	('2021-006',	'0101',	'TUR-000013',	'2020',	'casi nuevo',	'T',	'100000',	'vacio')
INSERT INTO Inventario VALUES	('2019-025',	'0401',	'TUR-000014',	'2019',	'usado',	'T',	'10000',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-026',	'0401',	'CAM-000012',	'2019',	'usado',	'T',	'5000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-027',	'0401',	'CAM-000013',	'2019',	'usado',	'T',	'90000',	'casi vacio')
INSERT INTO Inventario VALUES	('2019-028',	'0401',	'CAM-000014',	'2019',	'usado',	'T',	'15000',	'lleno')
INSERT INTO Inventario VALUES	('2019-029',	'0401',	'TUR-000015',	'2019',	'usado',	'T',	'30000',	'vacio')
INSERT INTO Inventario VALUES	('2019-030',	'0401',	'TUR-000016',	'2019',	'usado',	'T',	'99999',	'medio tanque')
INSERT INTO Inventario VALUES	('2019-031',	'0401',	'CAM-000022',	'2019',	'usado',	'T',	'87000',	'casi lleno')
INSERT INTO Inventario VALUES	('2019-032',	'0401',	'CAM-000023',	'2019',	'usado',	'T',	'100000',	'casi vacio')


INSERT INTO Servicio VALUES	('CH19-0001',	'Chofer',	'01/03/2019',	'02/02/2019')
INSERT INTO Servicio VALUES	('CH19-0002',	'Chofer',	'03/15/2019',	'03/30/2019')
INSERT INTO Servicio VALUES	('CH19-0003',	'Chofer',	'06/21/2019',	'08/21/2019')
INSERT INTO Servicio VALUES	('CH19-0004',	'Chofer',	'08/15/2019',	'08/25/2019')
INSERT INTO Servicio VALUES	('CH19-0005',	'Chofer',	'09/23/2019',	'11/01/2019')
INSERT INTO Servicio VALUES	('AL19-0001',	'Alquiler',	'01/21/2019',	'02/21/2019')
INSERT INTO Servicio VALUES	('AL19-0002',	'Alquiler',	'03/20/2019',	'04/01/2019')
INSERT INTO Servicio VALUES	('AL19-0003',	'Alquiler',	'05/05/2019',	'05/30/2019')
INSERT INTO Servicio VALUES	('AL19-0004',	'Alquiler',	'07/10/2019',	'08/10/2019')
INSERT INTO Servicio VALUES	('AL19-0005',	'Alquiler',	'10/04/2019',	'12/01/2019')
INSERT INTO Servicio VALUES	('CH20-0001',	'Chofer',	'01/03/2020',	'02/02/2020')
INSERT INTO Servicio VALUES	('CH20-0002',	'Chofer',	'03/15/2020',	'03/30/2020')
INSERT INTO Servicio VALUES	('CH20-0003',	'Chofer',	'06/21/2020',	'08/21/2020')
INSERT INTO Servicio VALUES	('AL20-0001',	'Alquiler',	'08/15/2020',	'08/25/2020')
INSERT INTO Servicio VALUES	('AL20-0002',	'Alquiler',	'09/23/2020',	'11/01/2020')
INSERT INTO Servicio VALUES	('AL20-0003',	'Alquiler',	'01/21/2020',	'02/21/2020')
INSERT INTO Servicio VALUES	('AL20-0004',	'Alquiler',	'03/20/2020',	'04/01/2020')
INSERT INTO Servicio VALUES	('AL20-0005',	'Alquiler',	'05/05/2020',	'05/30/2020')
INSERT INTO Servicio VALUES	('AL20-0006',	'Alquiler',	'07/10/2020',	'08/10/2020')
INSERT INTO Servicio VALUES	('AL20-0007',	'Alquiler',	'10/04/2020',	'12/01/2020')
INSERT INTO Servicio VALUES	('CH21-0001',	'Chofer',	'01/03/2021',	'02/02/2021')
INSERT INTO Servicio VALUES	('CH21-0002',	'Chofer',	'03/15/2021',	'03/30/2021')
INSERT INTO Servicio VALUES	('CH21-0003',	'Chofer',	'06/21/2021',	'07/21/2021')
INSERT INTO Servicio VALUES	('CH21-0004',	'Chofer',	'05/15/2021',	'05/25/2021')
INSERT INTO Servicio VALUES	('CH21-0005',	'Chofer',	'04/23/2021',	'06/01/2021')
INSERT INTO Servicio VALUES	('CH21-0006',	'Chofer',	'01/21/2021',	'02/21/2021')
INSERT INTO Servicio VALUES	('AL21-0007',	'Alquiler',	'03/20/2021',	'04/01/2021')
INSERT INTO Servicio VALUES	('AL21-0008',	'Alquiler',	'05/05/2021',	'05/30/2021')
INSERT INTO Servicio VALUES	('AL21-0009',	'Alquiler',	'07/10/2021',	'08/10/2021')
INSERT INTO Servicio VALUES	('AL21-0010',	'Alquiler',	'04/04/2021',	'06/01/2021')


INSERT INTO DetallePago VALUES	('CH19-0001',	'CH19-0001',	'MKT-01',	'23250',	'3487.5',	'26737.5')
INSERT INTO DetallePago VALUES	('CH19-0002',	'CH19-0002',	'MKT-02',	'9000',	'1350',	'10350')
INSERT INTO DetallePago VALUES	('CH19-0003',	'CH19-0003',	'MKT-03',	'18750',	'2812.5',	'21562.5')
INSERT INTO DetallePago VALUES	('CH19-0004',	'CH19-0004',	'MKT-04',	'23250',	'3487.5',	'26737.5')
INSERT INTO DetallePago VALUES	('CH19-0005',	'CH19-0005',	'MKT-01',	'43500',	'6525',	'50025')
INSERT INTO DetallePago VALUES	('AL19-0001',	'AL19-0001',	'MKT-02',	'7500',	'1125',	'8625')
INSERT INTO DetallePago VALUES	('AL19-0002',	'AL19-0002',	'MKT-03',	'29250',	'4387.5',	'33637.5')
INSERT INTO DetallePago VALUES	('AL19-0003',	'AL19-0003',	'MKT-04',	'23250',	'3487.5',	'26737.5')
INSERT INTO DetallePago VALUES	('AL19-0004',	'AL19-0004',	'MKT-01',	'9000',	'1350',	'10350')
INSERT INTO DetallePago VALUES	('AL19-0005',	'AL19-0005',	'MKT-02',	'18750',	'2812.5',	'21562.5')
INSERT INTO DetallePago VALUES	('CH20-0001',	'CH20-0001',	'MKT-03',	'23250',	'3487.5',	'26737.5')
INSERT INTO DetallePago VALUES	('CH20-0002',	'CH20-0002',	'MKT-04',	'43500',	'6525',	'50025')
INSERT INTO DetallePago VALUES	('CH20-0003',	'CH20-0003',	'MKT-01',	'9000',	'1350',	'10350')
INSERT INTO DetallePago VALUES	('AL20-0001',	'AL20-0001',	'MKT-02',	'18750',	'2812.5',	'21562.5')
INSERT INTO DetallePago VALUES	('AL20-0002',	'AL20-0002',	'MKT-03',	'23250',	'3487.5',	'26737.5')
INSERT INTO DetallePago VALUES	('AL20-0003',	'AL20-0003',	'MKT-04',	'43500',	'6525',	'50025')
INSERT INTO DetallePago VALUES	('AL20-0004',	'AL20-0004',	'MKT-01',	'22500',	'3375',	'25875')
INSERT INTO DetallePago VALUES	('AL20-0005',	'AL20-0005',	'MKT-02',	'11250',	'1687.5',	'12937.5')
INSERT INTO DetallePago VALUES	('AL20-0006',	'AL20-0006',	'MKT-03',	'45750',	'6862.5',	'52612.5')
INSERT INTO DetallePago VALUES	('AL20-0007',	'AL20-0007',	'MKT-04',	'7500',	'1125',	'8625')
INSERT INTO DetallePago VALUES	('CH21-0001',	'CH21-0001',	'MKT-01',	'29250',	'4387.5',	'33637.5')
INSERT INTO DetallePago VALUES	('CH21-0002',	'CH21-0002',	'MKT-02',	'22500',	'3375',	'25875')
INSERT INTO DetallePago VALUES	('CH21-0003',	'CH21-0003',	'MKT-03',	'11250',	'1687.5',	'12937.5')
INSERT INTO DetallePago VALUES	('CH21-0004',	'CH21-0004',	'MKT-04',	'45750',	'6862.5',	'52612.5')
INSERT INTO DetallePago VALUES	('CH21-0005',	'CH21-0005',	'MKT-01',	'22500',	'3375',	'25875')
INSERT INTO DetallePago VALUES	('CH21-0006',	'CH21-0006',	'MKT-02',	'11250',	'1687.5',	'12937.5')
INSERT INTO DetallePago VALUES	('AL21-0007',	'AL21-0007',	'MKT-03',	'22500',	'3375',	'25875')
INSERT INTO DetallePago VALUES	('AL21-0008',	'AL21-0008',	'MKT-04',	'7500',	'1125',	'8625')
INSERT INTO DetallePago VALUES	('AL21-0009',	'AL21-0009',	'MKT-01',	'29250',	'4387.5',	'33637.5')
INSERT INTO DetallePago VALUES	('AL21-0010',	'AL21-0010',	'MKT-02',	'23250',	'3487.5',	'26737.5')


INSERT INTO Factura VALUES	('CH19-0001',	'0801',	'0801-CAJ-01',	'01/03/2019',	'0801-0000001',	'efectivo',	'CH19-0001')
INSERT INTO Factura VALUES	('CH19-0002',	'0801',	'0801-CAJ-02',	'03/15/2019',	'0801-0000002',	'tarjeta',	'CH19-0002')
INSERT INTO Factura VALUES	('CH19-0003',	'0801',	'0801-CAJ-03',	'06/21/2019',	'0801-0000003',	'tarjeta',	'CH19-0003')
INSERT INTO Factura VALUES	('CH19-0004',	'0801',	'0801-CAJ-01',	'08/15/2019',	'0801-0000004',	'tarjeta',	'CH19-0004')
INSERT INTO Factura VALUES	('CH19-0005',	'0801',	'0801-CAJ-02',	'09/23/2019',	'0801-0000005',	'efectivo',	'CH19-0005')
INSERT INTO Factura VALUES	('AL19-0001',	'0801',	'0801-CAJ-03',	'01/21/2019',	'0801-0000006',	'efectivo',	'AL19-0001')
INSERT INTO Factura VALUES	('AL19-0002',	'0501',	'0501-CAJ-01',	'03/20/2019',	'0501-0000001',	'efectivo',	'AL19-0002')
INSERT INTO Factura VALUES	('AL19-0003',	'0501',	'0501-CAJ-02',	'05/05/2019',	'0501-0000002',	'efectivo',	'AL19-0003')
INSERT INTO Factura VALUES	('AL19-0004',	'0501',	'0501-CAJ-03',	'07/10/2019',	'0501-0000003',	'efectivo',	'AL19-0004')
INSERT INTO Factura VALUES	('AL19-0005',	'0501',	'0501-CAJ-01',	'10/04/2019',	'0501-0000004',	'efectivo',	'AL19-0005')
INSERT INTO Factura VALUES	('CH20-0001',	'0501',	'0501-CAJ-02',	'01/03/2020',	'0501-0000005',	'efectivo',	'CH20-0001')
INSERT INTO Factura VALUES	('CH20-0002',	'0501',	'0501-CAJ-03',	'03/15/2020',	'0501-0000006',	'efectivo',	'CH20-0002')
INSERT INTO Factura VALUES	('CH20-0003',	'0506',	'0506-CAJ-01',	'06/21/2020',	'0506-0000001',	'efectivo',	'CH20-0003')
INSERT INTO Factura VALUES	('AL20-0001',	'0506',	'0506-CAJ-02',	'08/15/2020',	'0506-0000002',	'efectivo',	'AL20-0001')
INSERT INTO Factura VALUES	('AL20-0002',	'0506',	'0506-CAJ-03',	'09/23/2020',	'0506-0000003',	'tarjeta',	'AL20-0002')
INSERT INTO Factura VALUES	('AL20-0003',	'0506',	'0506-CAJ-01',	'01/21/2020',	'0506-0000004',	'tarjeta',	'AL20-0003')
INSERT INTO Factura VALUES	('AL20-0004',	'0506',	'0506-CAJ-02',	'03/20/2020',	'0506-0000005',	'tarjeta',	'AL20-0004')
INSERT INTO Factura VALUES	('AL20-0005',	'0506',	'0506-CAJ-03',	'05/05/2020',	'0506-0000006',	'tarjeta',	'AL20-0005')
INSERT INTO Factura VALUES	('AL20-0006',	'0101',	'0101-CAJ-01',	'07/10/2020',	'0101-0000001',	'efectivo',	'AL20-0006')
INSERT INTO Factura VALUES	('AL20-0007',	'0101',	'0101-CAJ-02',	'10/04/2020',	'0101-0000002',	'tarjeta',	'AL20-0007')
INSERT INTO Factura VALUES	('CH21-0001',	'0101',	'0101-CAJ-03',	'01/03/2021',	'0101-0000003',	'tarjeta',	'CH21-0001')
INSERT INTO Factura VALUES	('CH21-0002',	'0101',	'0101-CAJ-01',	'03/15/2021',	'0101-0000004',	'tarjeta',	'CH21-0002')
INSERT INTO Factura VALUES	('CH21-0003',	'0101',	'0101-CAJ-02',	'06/21/2021',	'0101-0000005',	'tarjeta',	'CH21-0003')
INSERT INTO Factura VALUES	('CH21-0004',	'0101',	'0101-CAJ-03',	'05/15/2021',	'0101-0000006',	'tarjeta',	'CH21-0004')
INSERT INTO Factura VALUES	('CH21-0005',	'0401',	'0401-CAJ-01',	'04/23/2021',	'0401-0000001',	'efectivo',	'CH21-0005')
INSERT INTO Factura VALUES	('CH21-0006',	'0401',	'0401-CAJ-02',	'01/21/2021',	'0401-0000002',	'efectivo',	'CH21-0006')
INSERT INTO Factura VALUES	('AL21-0007',	'0401',	'0401-CAJ-03',	'03/20/2021',	'0401-0000003',	'efectivo',	'AL21-0007')
INSERT INTO Factura VALUES	('AL21-0008',	'0401',	'0401-CAJ-01',	'05/05/2021',	'0401-0000004',	'efectivo',	'AL21-0008')
INSERT INTO Factura VALUES	('AL21-0009',	'0401',	'0401-CAJ-02',	'07/10/2021',	'0401-0000005',	'efectivo',	'AL21-0009')
INSERT INTO Factura VALUES	('AL21-0010',	'0401',	'0401-CAJ-03',	'04/04/2021',	'0401-0000006',	'efectivo',	'AL21-0010')


SELECT * FROM Sucursal
SELECT * FROM Usuario
SELECT * FROM Rol
SELECT * FROM UsuarioRol
SELECT * FROM Cliente
SELECT * FROM Proveedor
SELECT * FROM Automovil 
SELECT * FROM Seguro
SELECT * FROM Servicio
SELECT * FROM Inventario
SELECT * FROM DetallePago
SELECT * FROM Factura
