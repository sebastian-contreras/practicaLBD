-- MySQL Script generated by MySQL Workbench
-- mié 28 jun 2023 09:06:02
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema examen2018
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `examen2018` ;

-- -----------------------------------------------------
-- Schema examen2018
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `examen2018` ;
USE `examen2018` ;

-- -----------------------------------------------------
-- Table `examen2018`.`Personas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`Personas` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`Personas` (
  `dni` INT NOT NULL,
  `apellido` VARCHAR(40) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`dni`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `examen2018`.`Cargos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`Cargos` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`Cargos` (
  `idCargo` INT NOT NULL,
  `cargo` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCargo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `examen2018`.`Trabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`Trabajos` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`Trabajos` (
  `idTrabajo` INT NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `duracion` INT NOT NULL DEFAULT 6,
  `area` ENUM('Hardware', 'Redes', 'Software') NOT NULL,
  `fechaPresentacion` DATE NOT NULL,
  `fechaAprobacion` DATE NOT NULL,
  `fechaFinalizacion` DATE NULL,
  PRIMARY KEY (`idTrabajo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `examen2018`.`Profesores`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`Profesores` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`Profesores` (
  `dni` INT NOT NULL,
  `idCargo` INT NOT NULL,
  PRIMARY KEY (`dni`),
  INDEX `fk_Profesores_Cargos1_idx` (`idCargo` ASC) VISIBLE,
  CONSTRAINT `fk_Profesores_Personas`
    FOREIGN KEY (`dni`)
    REFERENCES `examen2018`.`Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Profesores_Cargos1`
    FOREIGN KEY (`idCargo`)
    REFERENCES `examen2018`.`Cargos` (`idCargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `examen2018`.`Alumnos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`Alumnos` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`Alumnos` (
  `dni` INT NOT NULL,
  `cv` CHAR(7) NOT NULL,
  PRIMARY KEY (`dni`),
  UNIQUE INDEX `cv_UNIQUE` (`cv` ASC) VISIBLE,
  CONSTRAINT `fk_Alumnos_Personas1`
    FOREIGN KEY (`dni`)
    REFERENCES `examen2018`.`Personas` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `examen2018`.`RolesEnTrabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`RolesEnTrabajos` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`RolesEnTrabajos` (
  `idTrabajo` INT NOT NULL,
  `dni` INT NOT NULL,
  `rol` ENUM('Tutor', 'Cotutor', 'Jurado') NOT NULL,
  `desde` DATE NOT NULL,
  `hasta` DATE NULL,
  `razon` VARCHAR(100) NULL,
  PRIMARY KEY (`idTrabajo`, `dni`),
  INDEX `fk_Profesores_has_Trabajos_Trabajos1_idx` (`idTrabajo` ASC) VISIBLE,
  INDEX `fk_Profesores_has_Trabajos_Profesores1_idx` (`dni` ASC) VISIBLE,
  CONSTRAINT `fk_Profesores_has_Trabajos_Profesores1`
    FOREIGN KEY (`dni`)
    REFERENCES `examen2018`.`Profesores` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Profesores_has_Trabajos_Trabajos1`
    FOREIGN KEY (`idTrabajo`)
    REFERENCES `examen2018`.`Trabajos` (`idTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `examen2018`.`AlumnosEnTrabajos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `examen2018`.`AlumnosEnTrabajos` ;

CREATE TABLE IF NOT EXISTS `examen2018`.`AlumnosEnTrabajos` (
  `idTrabajo` INT NOT NULL,
  `dni` INT NOT NULL,
  `desde` DATE NOT NULL,
  `hasta` DATE NULL,
  `razon` VARCHAR(100) NULL,
  PRIMARY KEY (`idTrabajo`, `dni`),
  INDEX `fk_Alumnos_has_Trabajos_Trabajos1_idx` (`idTrabajo` ASC) VISIBLE,
  INDEX `fk_Alumnos_has_Trabajos_Alumnos1_idx` (`dni` ASC) VISIBLE,
  CONSTRAINT `fk_Alumnos_has_Trabajos_Alumnos1`
    FOREIGN KEY (`dni`)
    REFERENCES `examen2018`.`Alumnos` (`dni`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Alumnos_has_Trabajos_Trabajos1`
    FOREIGN KEY (`idTrabajo`)
    REFERENCES `examen2018`.`Trabajos` (`idTrabajo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
