-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Logistica_Almacen
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Logistica_Almacen
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Logistica_Almacen` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `Logistica_Almacen` ;

-- -----------------------------------------------------
-- Table `Logistica_Almacen`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Logistica_Almacen`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `rol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `Logistica_Almacen`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Logistica_Almacen`.`usuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellido` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `contraseña` VARCHAR(250) NOT NULL,
  `rol_id` INT NULL,
  `token` VARCHAR(250) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_usuarios_roles1_idx` (`rol_id` ASC),
  CONSTRAINT `fk_usuarios_roles1`
    FOREIGN KEY (`rol_id`)
    REFERENCES `Logistica_Almacen`.`roles` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `Logistica_Almacen`.`almacenes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Logistica_Almacen`.`almacenes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `responsable_id` INT NULL,
  `direccion` VARCHAR(255) NULL,
  `ciudad` VARCHAR(255) NULL,
  `codigo_postal` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_almacenes_usuarios1_idx` (`responsable_id` ASC),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC),
  CONSTRAINT `fk_almacenes_usuarios1`
    FOREIGN KEY (`responsable_id`)
    REFERENCES `Logistica_Almacen`.`usuarios` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `Logistica_Almacen`.`estados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Logistica_Almacen`.`estados` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `estado` VARCHAR(25) NOT NULL,
  `descripción` VARCHAR(100) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Logistica_Almacen`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Logistica_Almacen`.`pedidos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha_creacion` DATETIME NOT NULL,
  `fecha_salida` DATETIME NULL,
  `matricula` VARCHAR(15) NULL,
  `operario` INT NOT NULL,
  `detalles` LONGTEXT NULL,
  `comentario_error` LONGTEXT NULL,
  `almacen_origen_id` INT NULL,
  `almacen_destino_id` INT NULL,
  `responsable_id` INT NULL,
  `estado_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pedidos_almacenes1_idx` (`almacen_origen_id` ASC),
  INDEX `fk_pedidos_almacenes2_idx` (`almacen_destino_id` ASC),
  INDEX `fk_pedidos_usuarios1_idx` (`responsable_id` ASC),
  INDEX `fk_pedidos_estados1_idx` (`estado_id` ASC),
  CONSTRAINT `fk_pedidos_almacenes1`
    FOREIGN KEY (`almacen_origen_id`)
    REFERENCES `Logistica_Almacen`.`almacenes` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_almacenes2`
    FOREIGN KEY (`almacen_destino_id`)
    REFERENCES `Logistica_Almacen`.`almacenes` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_usuarios1`
    FOREIGN KEY (`responsable_id`)
    REFERENCES `Logistica_Almacen`.`usuarios` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_estados1`
    FOREIGN KEY (`estado_id`)
    REFERENCES `Logistica_Almacen`.`estados` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- INSERTS TABLA ROLES`
-- -----------------------------------------------------

INSERT INTO `Logistica_Almacen`.`roles` (`rol`) VALUES ('operario');
INSERT INTO `Logistica_Almacen`.`roles` (`rol`) VALUES ('encargado');
INSERT INTO `Logistica_Almacen`.`roles` (`rol`) VALUES ('jefe de equipo');

-- -----------------------------------------------------
-- INSERTS TABLA ESTADOS`
-- -----------------------------------------------------

INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('NUEVO', 'El pedido ha sido creado');
INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('PTE_SALIDA', 'El pedido ha quedado pendiente de revisión para su salida por el encargado del almacén de salida');
INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('ERROR', 'El pedido ha sido como marcado como erróneo por el encargado del almacén');
INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('LISTO_SALIDA', 'El pedido ha sido marcado como correcto por el encargado del almacén de salida');
INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('PTE_ENTRADA', 'El pedido ha quedado pendiente de revisión para su entrada por el encargado del almacén de entrada');
INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('LISTO_ENTRADA', 'El pedido ha sido marcado como correcto por el encargado del almacén de entrada');
INSERT INTO `Logistica_Almacen`.`estados` (`estado`, `descripción`) VALUES ('CERRADO', 'El pedido ha sido cerrado');

-- -----------------------------------------------------
-- INSERTS TABLA USUARIOS`
-- -----------------------------------------------------
INSERT INTO `Logistica_Almacen`.`usuarios` (`nombre`, `apellido`, `email`, `contraseña`,`rol_id`) VALUES ('Joaquín', 'Reyes', 'jreyes@gmail.com', '$2a$08$0TBM86/kdWq2MO4kO9Dur.Lhr7bN4dTPJdZ0JDj4BjqfMGJrPgSLm',1);