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
	