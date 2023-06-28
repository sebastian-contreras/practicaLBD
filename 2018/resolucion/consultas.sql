-- Problema 2
DROP PROCEDURE IF EXISTS DetalleRoles;
DELIMITER // 
CREATE PROCEDURE DetalleRoles(
desde DATE, hasta Date,out mensaje varchar(100)
)
SALIR:BEGIN 
			START TRANSACTION; 
            SELECT r.desde,p.dni,p.nombres,p.apellido , sum(r.rol='Jurado') as 'Jurado', sum(r.rol='Tutor')  as 'Tutor', sum(r.rol='Cotutor')  as 'Cotutor'
			FROM Personas as p JOIN Profesores as pr on p.dni=pr.dni
			join RolesEnTrabajos as r on pr.dni=r.dni where r.desde BETWEEN desde and hasta
			group by r.dni;
			SET mensaje = 'Busqueda con exito';
			COMMIT; 
END 
// DELIMITER ; 
call DetalleRoles('2016-01-01','2018-01-01',@mensaje);
select @mensaje;
  SELECT r.desde,p.dni,p.nombres,p.apellido,r.rol  , sum(case when r.rol='Jurado' then 1 else 0 end) as 'Jurado', sum(r.rol='Tutor')  as 'Tutor', sum(r.rol='Cotutor')  as 'Cotutor'
			FROM Personas as p JOIN Profesores as pr on p.dni=pr.dni
			join RolesEnTrabajos as r on pr.dni=r.dni -- where r.desde BETWEEN desde and hasta
             group by r.dni
			;
-- Problema 3
DROP PROCEDURE IF EXISTS NuevoTrabajo;
DELIMITER // 
CREATE PROCEDURE NuevoTrabajo(
 `eidTrabajo` INT ,
  `etitulo` VARCHAR(100) ,
  `eduracion` INT,
  `earea` ENUM('Hardware', 'Redes', 'Software'),
  `efechaPresentacion` DATE,
  `efechaAprobacion` DATE ,
  `efechaFinalizacion` DATE,
   OUT mensaje VARCHAR(100)
)
SALIR:BEGIN 
			IF EXISTS(select * from Trabajos where idTrabajo=eidTrabajo) then
				SET mensaje = 'El ID ya existe';
			ELSEIF YEAR(efechaPresentacion)>YEAR(efechaAprobacion) then
				SET mensaje = 'Colocar Fecha correcta';
				LEAVE SALIR;
			ELSE
				START TRANSACTION; 
                INSERT INTO `examen2018`.`Trabajos` (`idTrabajo`, `titulo`, `duracion`, `area`, `fechaPresentacion`, `fechaAprobacion`, `fechaFinalizacion`) VALUES (`eidTrabajo`, `etitulo`, `eduracion`, `earea`, `efechaPresentacion`, `efechaAprobacion`, `efechaFinalizacion`);
				SET mensaje = 'Trabajo creada con exito';
				COMMIT; 
			END IF;
END 
// DELIMITER ; 
call NuevoTrabajo(7, 'Sistema de seguimiento de egresados', 6, 'Software', '2018-03-01', '2018-05-24', '2019-05-24',@mensaje);
select @mensaje;
call NuevoTrabajo(35, 'Sistema de seguimiento', 6, 'Software', '2023-03-01', '2018-05-24', '2019-05-24',@mensaje);
select @mensaje;
call NuevoTrabajo(67, 'Sistema de seguimiento', 6, 'Software', '2018-03-01', '2022-05-24', '2023-05-24',@mensaje);
select @mensaje;
call NuevoTrabajo(27, 'SisStemaS', 25, 'Software', '2018-03-01', '2022-05-24', '2023-05-24',@mensaje);
select @mensaje;
select * from AuditoriaTrabajos;


-- problema 4
-- Tabla Auditoria Trabajos
DROP TABLE IF EXISTS `AuditoriaTrabajos` ;
CREATE TABLE IF NOT EXISTS `AuditoriaTrabajos` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `idTrabajo` INT NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `duracion` INT NOT NULL DEFAULT 6,
  `area` ENUM('Hardware', 'Redes', 'Software') NOT NULL,
  `fechaPresentacion` DATE NOT NULL,
  `fechaAprobacion` DATE NOT NULL,
  `fechaFinalizacion` DATE NULL,
  `TipoAccion` CHAR(1) NOT NULL, -- tipo de operación (I: Inserción, B: Borrado, M: Modificación)
  `Usuario` VARCHAR(45) NOT NULL,  
  `Maquina` VARCHAR(45) NOT NULL,  
  `Fecha` DATETIME NOT NULL,
  PRIMARY KEY (`ID`)
);
-- Creacion trigger
DROP TRIGGER IF EXISTS `trig_Trabajos_Creados` ;

DELIMITER //
CREATE TRIGGER `trig_Trabajos_Creados` 
AFTER INSERT ON `Trabajos` FOR EACH ROW
SALIR:BEGIN
	IF (new.duracion>12 OR new.duracion < 3) THEN
	INSERT INTO AuditoriaTrabajos VALUES (
		DEFAULT,
        new.idTrabajo,
		new.titulo,
		new.duracion, 
        new.area,
        new.fechaPresentacion,
        new.fechaAprobacion,
        new.fechaFinalizacion,
		'I', 
		SUBSTRING_INDEX(USER(), '@', 1), 
		SUBSTRING_INDEX(USER(), '@', -1), 
		NOW()
	);
    END IF;
END //
DELIMITER ;

SELECT p.dni,p.nombres,p.apellido , sum(r.rol='Jurado') as 'Jurado', sum(r.rol='Tutor')  as 'Tutor', sum(r.rol='Cotutor')  as 'Cotutor'
FROM Personas as p JOIN Profesores as pr on p.dni=pr.dni
join RolesEnTrabajos as r on pr.dni=r.dni
group by r.dni;
