-- Punto 2
CREATE VIEW VCantidadPeliculas
AS 
select p.idPelicula,p.titulo,count(p.idPelicula) as cantidad 
from Peliculas as p join Inventario as i on p.idPelicula=i.idPelicula
group by(p.idPelicula) order by (p.titulo) ASC;
select * from VCantidadPeliculas;

-- Punto 3
DROP PROCEDURE IF EXISTS NuevaDireccion;
DELIMITER // 
CREATE PROCEDURE NuevaDireccion(
  `eidDireccion` INT ,
  `ecalleYNumero` VARCHAR(50) ,
  `emunicipio` VARCHAR(20),
  `ecodigoPostal` VARCHAR(10),
  `etelefono` VARCHAR(20),
   OUT mensaje VARCHAR(100)
)
SALIR:BEGIN 
		IF EXISTS (select * from Direcciones where idDireccion=eidDireccion) THEN 
			SET	mensaje = 'ID ya existe';
			LEAVE SALIR;    
            ELSEIF EXISTS (select * from Direcciones where calleYNumero=ecalleYNumero) THEN 
			SET	mensaje = 'calle Y Numero duplicado';
			LEAVE SALIR;  
		ELSE 
			START TRANSACTION; 
			INSERT INTO `Examen2021`.`Direcciones` (`idDireccion`, `calleYNumero`, `municipio`, `codigoPostal`, `telefono`) VALUES (eidDireccion, ecalleYNumero, emunicipio, ecodigoPostal, etelefono);                
			SET mensaje = 'Direccion creada con exito';
			COMMIT; 
	END IF; 
END 
// DELIMITER ; 
call NuevaDireccion(1,'47 MySakila Drive','Alberta','-','-',@mensaje);
select @mensaje;

call NuevaDireccion(5422,'47 sasySakila','Alberta','-','-',@mensaje);
select @mensaje;

select * from Direcciones;
-- Estructura de store
DROP PROCEDURE IF EXISTS NuevaDireccion;
DELIMITER // 
CREATE PROCEDURE NuevaDireccion(
)
SALIR:BEGIN 
			START TRANSACTION; 
			SET mensaje = 'Direccion creada con exito';
			COMMIT; 
END 
// DELIMITER ; 


-- Punto 4
DROP PROCEDURE IF EXISTS BuscarPeliculasPorGenero;
DELIMITER // 
CREATE PROCEDURE BuscarPeliculasPorGenero(ecodigoGenero CHAR(10),OUT mensaje VARCHAR(100))
SALIR:BEGIN 
			START TRANSACTION; 
            Select p.idPelicula,p.titulo,s.idSucursal,count(*) as "Cantidad", d.calleYNumero
from Generos AS g join GenerosDePeliculas as gp on  g.idGenero=gp.idGenero
join Peliculas as p on gp.idPelicula=p.idPelicula
join Inventario as i on i.idPelicula=p.idPelicula
join Sucursales as s on i.idSucursal=s.idSucursal
join Direcciones as d on s.idDireccion=d.idDireccion 
where g.idGenero = ecodigoGenero
 group by i.idPelicula,i.idSucursal;
			SET mensaje = 'Busqueda exitosa';
			COMMIT; 
END 
// DELIMITER ; 
call BuscarPeliculasPorGenero("11",@mensaje);
select @mensaje;


select * from Peliculas as p join Inventario as i on p.idPelicula=i.idPelicula;