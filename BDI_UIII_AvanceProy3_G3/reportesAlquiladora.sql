USE YLP_TLC

  SELECT Factura.idFactura Codigo_Factura	-- para renombrar el atributo cuando se muestre la salida
      ,Factura.sucursal 
	  ,Sucursal.ciudad	Ciudad_Sucursal		-- para renombrar el atributo cuando se muestre la salida
      ,Factura.fecha
      ,Factura.usuario 						-- Para solo mostrar el año (2021) se usa YEAR, Se usa SUM para hacer la suma de alguna venta
      ,Cliente.[nombre]
	  ,Cliente.[apellido]					-- Para cruzar la informacioón a mostrar con la tabal cliente, para visualizar el nombre y apellido del cliente que esta pagando.												
      ,UsuarioRol.rol
	  ,Rol.rol
	  ,[tipoPago]
      ,[detallePago]
	  ,Inventario.automovil
	  ,Inventario.disponibilidad
	  ,Automovil.marca
	  ,Automovil.tipoAuto
	  ,Proveedor.nombre Proveedor
	  ,Proveedor.producto Seguro_Auto
	  ,Servicio.tipoServicio
	 	  
  FROM [YLP_TLC].[dbo].[Factura]
	INNER JOIN Cliente ON Factura.cliente = Cliente.idCliente				--Este INNER JOIN cruza la iformación de la tabla Cliente con Factura por medio de las PK
	INNER JOIN Sucursal ON Factura.sucursal = Sucursal.idSucursal			--Este INNER JOIN cruza la iformación de la tabla Sucursal con Factura por medio de las PK
	INNER JOIN Inventario ON Factura.sucursal = Inventario.sucursal			--Este INNER JOIN cruza la iformación de la tabla Inventario con Factura por medio de las PK
	INNER JOIN Automovil ON Inventario.automovil = Automovil.idAutomovil	--Este INNER JOIN cruza la iformación de la tabla Automovil con Inventario por medio de las PK
	INNER JOIN Proveedor ON Automovil.proveedor = Proveedor.idProveedor		--Este INNER JOIN cruza la iformación de la tabla Proveedor con Automovil cpor medio de las PK
	INNER JOIN DetallePago ON Factura.detallePago = DetallePago.idDetalle	--Este INNER JOIN cruza la iformación de la tabla DetallePago con Factura por medio de las PK
	INNER JOIN Servicio ON DetallePago.servicio = Servicio.idServicio		--Este INNER JOIN cruza la iformación de la tabla Servicio con DetallePago por medio de las PK
	INNER JOIN UsuarioRol ON Factura.usuario = UsuarioRol.usuario			--Este INNER JOIN cruza la iformación de la UsuarioRol con Factura por medio de las PK
	INNER JOIN Rol ON UsuarioRol.rol = Rol.idRol							--Este INNER JOIN cruza la iformación de la tabla Rol con UsuarioRol por medio de las PK

	-- Para agregar condicionantes a la busqueda en las tablas.
	Where Sucursal.ciudad = 'Tegucigalpa'  -- Para mostrar solo la iformación de las sucursales en Tegucigalpa
	AND Factura.tipoPago = 'efectivo'	   -- Para mostrar solo la iformación de las facturas que pagaron con tarjeta
	AND Inventario.automovil = 'TUR-000002'
	GROUP BY Factura.idFactura 
      ,Factura.sucursal
	  ,Sucursal.ciudad
      ,Factura.fecha
      ,Factura.usuario 		  -- Para solo mostrar el año (2021) se usa YEAR, Se usa SUM para hacer la suma de alguna venta
      ,Cliente.[nombre]
	  ,Cliente.[apellido]    											
      ,UsuarioRol.rol
	  ,Rol.rol
	  ,[tipoPago]
      ,[detallePago]  
	  ,Inventario.automovil
	  ,Inventario.disponibilidad
	  ,Automovil.marca
	  ,Automovil.tipoAuto
	  ,Proveedor.nombre 
	  ,Proveedor.producto 	
	  ,Servicio.tipoServicio
	  	
	ORDER BY Factura.fecha ASC --ASC Ordena en forma ascendente -- DESC Ordena en forma descendente 
	
	SELECT Count(1) FROM Sucursal
	SELECT departamento from Sucursal

	SELECT TOP 10 [idAutomovil]
      ,[proveedor]
      ,[tipoAuto]
      ,[marca]
      ,[modelo]
      ,[placa]
      ,[anio]
	FROM [YLP_TLC].[dbo].[Automovil]
	UPDATE Automovil SET modelo= 'CX-1' WHERE idAutomovil ='CAM-000001'
	-- Para poder actulizar o editar la información de una tupla

	DELETE FROM Automovil WHERE  idAutomovil = 'CAM-000001'
  -- Para poder ejecutar esta sentencia, y poder eliminar un automovil, es necesario 
  -- Eliminar primeramente el registro en inventario, porque esta enlazado mediante la
  -- llave foranea, y no permitira borrar, mientras no sea borrado primeramente en la tabla 
  -- de inventario.

	DELETE FROM Inventario WHERE  automovil = 'CAM-000001'
  -- Eliminando la tubla de la tabla Inventario podra eliminarse de la tabla Automovil
  -- A continuación el Select que demuestra que que efectivamente la tupla esta
  -- eliminada.

	SELECT TOP 10   [idInventario]
      ,[sucursal]
      ,[automovil]
      ,[añoAdquisicion]
      ,[estado]
      ,[disponibilidad]
      ,[kilometraje]
      ,[combustible]
	FROM [YLP_TLC].[dbo].[Inventario] 
	INNER JOIN Automovil ON Inventario.automovil = Automovil.idAutomovil
	Where idAutomovil = 'CAM-000001'

--Contando los registros de cada tabla
SELECT COUNT(*) CantidadSucursales FROM Sucursal

SELECT COUNT(*) CantidadEmpleadosPorSucursal, S.ciudad FROM Usuario U
	INNER JOIN Sucursal S ON U.sucursal = S.idSucursal
	GROUP BY S.ciudad

SELECT COUNT(*) CantidadEmpleadosPorRol, R.rol FROM Usuario U
	INNER JOIN UsuarioRol UR ON U.idUsuario = UR.usuario
	INNER JOIN Rol R ON UR.rol = R.idRol
	GROUP BY R.rol

SELECT COUNT(*) CLIENTESPORSUCURSAL, S.ciudad FROM Factura F
	INNER JOIN Cliente C ON F.cliente = C.idCliente
	INNER JOIN Sucursal S ON F.sucursal = S.idSucursal
	GROUP BY S.ciudad
SELECT * FROM Factura
SELECT * FROM DetallePago

--FORMATO DE UNA FACTURA
SELECT	F.sucursal,
		U.idUsuario,
		U.nombre,
		U.apellido,
		--R.rol,
		C.id,
		C.nombre,
		C.apellido,
		F.tipoPago,
		F.fecha,
		SER.tipoServicio,
		A.marca,
		A.modelo,
		A.anio,
		I.kilometraje,
		I.combustible,
		SE.nombre,
		DP.subtotal,
		DP.isv,
		DP.total,
		S.ciudad 
		FROM Factura F
	INNER JOIN Usuario U ON F.usuario = U.idUsuario
	INNER JOIN UsuarioRol UR ON U.idUsuario = UR.usuario
	INNER JOIN Rol R ON UR.rol = R.idRol
	INNER JOIN Cliente C ON F.cliente = C.idCliente
	INNER JOIN DetallePago DP ON F.detallePago = DP.idDetalle
	INNER JOIN Servicio SER ON DP.servicio = SER.idServicio
	INNER JOIN Sucursal S ON F.sucursal = S.idSucursal			
	INNER JOIN Inventario I ON F.sucursal = I.sucursal			
	INNER JOIN Automovil A ON I.automovil = A.idAutomovil
	INNER JOIN Seguro SE ON DP.seguro = SE.idSeguro
	GROUP BY F.sucursal,
		U.idUsuario,
		U.nombre,
		U.apellido,
		--R.rol,
		C.id,
		C.nombre,
		C.apellido,
		F.tipoPago,
		F.fecha,
		SER.tipoServicio,
		A.marca,
		A.modelo,
		A.anio,
		I.kilometraje,
		I.combustible,
		SE.nombre,
		DP.subtotal,
		DP.isv,
		DP.total,
		S.ciudad 
	HAVING DP.total < 20000
	ORDER BY DP.total DESC
