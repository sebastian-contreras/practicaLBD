-- Punto 2 Creacion de vista
CREATE VIEW VCantidadVentas
AS 
select t.idTienda, COUNT(t.idTienda) as "Cantidad de ventas" ,SUM(d.cantidad*Titulos.precio) as "Importe total"
from Tiendas as t left join Ventas as v on t.idTienda = v.idTienda 
join Detalles as d on d.codigoVenta = v.codigoVenta
join Titulos on d.idTitulo = Titulos.idTitulo
 group by (t.idTienda)
;
select * from VCantidadVentas;

-- Punto 3 Store procedure
DROP PROCEDURE IF EXISTS NuevaEditorial;
DELIMITER // 
CREATE PROCEDURE NuevaEditorial( 
    `eidEditorial` CHAR(4),
	`enombre` VARCHAR(40), 
    `eciudad` VARCHAR(20), 
     `eestado` CHAR(2),
     `epais` VARCHAR(30),
    OUT mensaje VARCHAR(100))
-- Crea una mascota siempre y cuando no haya otro con el mismo id 
SALIR:BEGIN 
		IF EXISTS (select * from Editoriales where idEditorial=eidEditorial) THEN 
			SET	mensaje = 'ID ya existe';
			LEAVE SALIR;    
            ELSEIF EXISTS (select * from Editoriales where nombre=enombre) THEN 
			SET	mensaje = 'Nombre duplicado';
			LEAVE SALIR;  
		ELSE 
			START TRANSACTION; 
				INSERT INTO `Parcial2022`.`Editoriales` (`idEditorial`, `nombre`, `ciudad`, `estado`, `pais`) VALUES 				(eidEditorial, enombre, eciudad, eestado, epais);
                SET mensaje = 'Editorial creada con exito';
			COMMIT; 
	END IF; 
END 
// DELIMITER ; 
-- Prueba Erronea Nombre duplicado
call NuevaEditorial('1223', 'New Moon Books', 'Boston', 'MA', 'USA',@resultado);
select @resultado as MENSAJE;
-- Prueba Erronea id duplicado
call NuevaEditorial('0736', 'Error', 'Boston', 'MA', 'USA',@resultado);
select @resultado as MENSAJE;
-- Prueba Correcta
call NuevaEditorial('4136', 'pruebaAACorrecta', 'Boston', 'MA', 'USA',@resultado);
select @resultado as MENSAJE;

-- Punto 4 Busqueda

DROP PROCEDURE IF EXISTS BuscarTitulosPorAutor;

DELIMITER //
CREATE PROCEDURE BuscarTitulosPorAutor(
	codigo VARCHAR(11), 
    OUT mensaje VARCHAR(100))
SALIR: BEGIN 
	IF(codigo IS NULL) THEN 
		SET mensaje = 'Error al ingresar codigo autor';
		LEAVE SALIR;
    ELSE
		START TRANSACTION;
select Titulos.idTitulo, Titulos.titulo,Titulos.genero,Editoriales.nombre,Titulos.precio,Titulos.sinopsis,Titulos.fechaPublicacion
from Autores as a join TitulosDelAutor as t on a.idAutor=t.idAutor
join Titulos on t.idTitulo = Titulos.idTitulo
join Editoriales on Titulos.idEditorial = Editoriales.idEditorial
 where t.idAutor = codigo ORDER BY Titulos.idTitulo;
            SET mensaje ='Consulta correcta';
        COMMIT;
	END IF;
END //
DELIMITER ;

call BuscarTitulosPorAutor("409-56-7008",@resultado);
select @resultado;

-- Punto 5 Trigger
-- Tabla Auditoria Editorial
DROP TABLE IF EXISTS `AuditoriaEditorial` ;
CREATE TABLE IF NOT EXISTS `AuditoriaEditorial` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `idEditorial` CHAR(4) NOT NULL,
  `nombre` VARCHAR(40) NOT NULL,
  `ciudad` VARCHAR(20) NULL,
  `estado` CHAR(2) NULL,
  `pais` VARCHAR(30) NOT NULL DEFAULT 'USA',
  `TipoAccion` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);

-- Creacion trigger
DROP TRIGGER IF EXISTS `trig_Editoriales_Borrado` ;

DELIMITER //
CREATE TRIGGER `trig_Editoriales_Borrado` 
BEFORE DELETE ON `Editoriales` FOR EACH ROW
SALIR:BEGIN
	IF EXISTS(select * from Editoriales join Titulos on Editoriales.idEditorial=Titulos.idEditorial where Editoriales.idEditorial=OLD.idEditorial) then
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: no se puede borrar ya que hay datos asociados';
    leave SALIR;
    ELSE
	INSERT INTO AuditoriaEditorial VALUES (
		DEFAULT,
        OLD.idEditorial,
		OLD.nombre,
		OLD.ciudad, 
        OLD.estado,
        OLD.pais,
		'B', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    END IF;
END //
DELIMITER ;
select * from Editoriales;
insert Editoriales values('9929', 'ucerne Publishing', 'Paris', NULL, 'France');

delete from Editoriales where idEditorial="9929";
select * from AuditoriaEditorial;


