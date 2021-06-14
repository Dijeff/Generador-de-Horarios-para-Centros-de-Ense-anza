-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 09-12-2020 a las 03:05:26
-- Versión del servidor: 10.3.16-MariaDB
-- Versión de PHP: 7.3.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `id15465931_apswbd`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `AgregarGrupo` (IN `des` VARCHAR(100), IN `tamano` VARCHAR(150), IN `dian` VARCHAR(100), IN `horaini` VARCHAR(100), IN `horafin` VARCHAR(100), IN `nomb_pro` VARCHAR(100), IN `curso` VARCHAR(100), IN `id` VARCHAR(50))  NO SQL
BEGIN
select @hora := cod_horario from horario where hora_inicio = horaini and hora_fin = horafin and dia = dian;

select @curs := id_curso from cursos where CodUnico = curso;

select @var := count(*) from grupos2 where descripcion = des and cod_horario = @hora and id_curso=@curs and id_curso = id;

  if(@var=0)
 	THEN 
    
       INSERT INTO `grupos2`(`descripcion`, `tamaño`, `cod_horario`,`nombre_profesor`, `id_curso`, `id_grupo`) 
                        VALUES (des,tamano,@hora,nomb_pro, @curs, id);

    
      SELECT @codigo_aula := aulas.cod_aula from aulas where aulas.cod_aula not in(select aulas_x_disponibilidad.cod_aula FROM aulas_x_disponibilidad, grupo_x_aula, aulas WHERE aulas_x_disponibilidad.cod_horario = @hora AND  aulas_x_disponibilidad.cod_aula = aulas.cod_aula AND aulas_x_disponibilidad.id_disponibilidad = grupo_x_aula.cod_aula) AND capacidad >= tamano AND cod_tipo != 3 and cod_tipo != 4 limit 1;

      if (@codigo_aula IS NOT NULL)
      THEN
      		INSERT INTO aulas_x_disponibilidad 
            (cod_aula, cod_horario, Disponibilidad)
            VALUES(@codigo_aula, @hora, 2);
         
             SELECT @dispo:= MAX(id_disponibilidad) 
             FROM aulas_x_disponibilidad;
             
              SELECT @grup:= MAX(cod_grupo) FROM grupos2;
             
             INSERT INTO grupo_x_aula (cod_aula, cod_grupo)
             values(@dispo, @grup);
            
            
      END IF; 

                    
    END IF;
 END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `agregarhorariop` (IN `dian` VARCHAR(50), IN `inicio` VARCHAR(100), IN `fin` VARCHAR(100), IN `cod` VARCHAR(100), IN `fechaI` DATE, IN `fechaF` DATE)  NO SQL
BEGIN
select @var := count(*) from horario where hora_inicio = inicio and hora_fin = fin and dia = dian;

select @peri := cod_periodo from periodos where fecha_inicio = fechaI and fecha_final = fechaF;

  if(@var=0)
 	THEN 
    
    select @codOfe := cod_oferta from ofertaacademica where nombre = cod;
    
       INSERT INTO `horario`(`dia`, `hora_inicio`, `hora_fin`,`cod_oferta`,`cod_periodo`) 
                        VALUES (dian,inicio,fin,@codOfe,@peri);
                        
                          
    END IF;
 END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `agregarOferta` (IN `nom` VARCHAR(50), IN `arch` VARCHAR(50), IN `ini` DATE, IN `fin` DATE)  NO SQL
BEGIN
  select @var := count(*) from ofertaacademica where nombre = nom;
  if(@var=0)
 	THEN 
        INSERT INTO `ofertaacademica`(`nombre`,`archivo`,`fecha_inicio`,`fecha_fin`) 
                        VALUES (nom, arch,ini,fin);

    END IF;
    END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `AgregarPeriodo` (IN `ini` DATE, IN `fin` DATE)  NO SQL
BEGIN
  select @var := count(*) from periodos where fecha_inicio = ini and fecha_final = fin;
  if(@var=0)
 	THEN 
        INSERT INTO `periodos`(`fecha_inicio`,`fecha_final`) 
                        VALUES (ini,fin);

    END IF;
    END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `eliminar_grupo_aula` (IN `gru` INT, IN `aul` INT)  BEGIN



	DECLARE hola  INT unsigned DEFAULT 1; 
    
	DECLARE hola2  INT unsigned DEFAULT 1; 
    
    select grupos2.cod_horario into hola2 from grupos2 WHERE grupos2.cod_grupo=gru;

    select aulas_x_disponibilidad.id_disponibilidad into hola from aulas_x_disponibilidad WHERE aulas_x_disponibilidad.cod_aula=aul and aulas_x_disponibilidad.cod_horario=hola2;
    
    
    UPDATE `aulas_x_disponibilidad` SET `Disponibilidad`=1 WHERE aulas_x_disponibilidad.id_disponibilidad=hola;


 DELETE FROM `grupo_x_aula` WHERE grupo_x_aula.cod_aula=hola and `cod_grupo`=gru;
 
 
 
 
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `ingresar_grupo_manual` (IN `des` VARCHAR(100), IN `ta` VARCHAR(100), IN `dia` VARCHAR(100), IN `nom` VARCHAR(100), IN `cur` VARCHAR(100), IN `gru` INT)  BEGIN
DECLARE hola2  INT unsigned DEFAULT 1;
DECLARE hola  INT unsigned DEFAULT 1;
DECLARE ho  INT unsigned DEFAULT 1;



   SELECT  cursos.id_curso into hola from cursos where cursos.descripcion3=cur;
   
   
   
      SELECT  horario.cod_horario into ho from horario where horario.dia=dia LIMIT 1 ;
   
  

INSERT INTO `grupos2`( `descripcion`, `tamaño`, `cod_horario`, `nombre_profesor`, `id_curso`, id_grupo) VALUES (des,ta,ho,nom,hola,gru);



END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `ingresar_solicitud` (IN `gru` INT, IN `au` INT, IN `en` INT, IN `re` VARCHAR(100), IN `ti` VARCHAR(100), IN `asun` VARCHAR(100), IN `mensa` VARCHAR(100))  BEGIN
DECLARE hola2  INT unsigned DEFAULT 1;
DECLARE hola  INT unsigned DEFAULT 1;
DECLARE ho  INT unsigned DEFAULT 1;

SELECT personas.id_persona into hola FROM personas where personas.correo=re;

   INSERT INTO `solicitudes`( `grupo`, `aula`, `user_envio`, `user_recibo`, `estado`, `titulo`, `asunto`, `mensaje`) VALUES (gru,au,en,hola,1,ti,asun,mensa);
 
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `InsertarCarreras` (IN `descr` VARCHAR(100))  NO SQL
BEGIN
  select @var := count(*) from carreras where descripcion = descr;
  if(@var=0)
 	THEN 
        INSERT INTO `carreras`(`descripcion`) 
                        VALUES (descr);

    END IF;
    END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `InsertarCursos` (IN `cod` VARCHAR(50), IN `des` VARCHAR(150), IN `car` VARCHAR(100))  NO SQL
BEGIN
select @var := count(*) from cursos where CodUnico = cod;

  if(@var=0)
 	THEN 
    
    select @codCa := id_carrera from carreras where descripcion = car;
    
       INSERT INTO `cursos`(`CodUnico`, `descripcion3`, `id_carrera`) 
                        VALUES (cod,des,@codCa);
    END IF;
 END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_aulas` (IN `edi` INT)  BEGIN
SELECT aulas.cod_aula ,aulas.descripcion, capacidad, ubicacion, tipo_de_aula.descripcion2,estado  FROM aulas,tipo_de_aula WHERE aulas.cod_tipo=tipo_de_aula.cod_tipo and aulas.cod_edificio=edi ;
  
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_aulasd` ()  BEGIN

 

SELECT DISTINCT aulas.cod_aula, edificios.descripcion as name , horario.dia, horario.hora_inicio, horario.hora_fin, aulas.descripcion, tipo_de_aula.descripcion2, aulas.capacidad, aulas_x_disponibilidad.Disponibilidad , grupos2.descripcion as grupodes, grupos2.nombre_profesor , grupos2.id_grupo FROM edificios,`aulas`,tipo_de_aula, aulas_x_disponibilidad,grupo_x_aula,grupos2,horario,cursos WHERE edificios.cod_edificio=aulas.cod_edificio and tipo_de_aula.cod_tipo=aulas.cod_tipo and aulas.cod_aula=aulas_x_disponibilidad.cod_aula and aulas_x_disponibilidad.id_disponibilidad=grupo_x_aula.cod_aula and grupo_x_aula.cod_grupo= grupos2.cod_grupo and grupos2.cod_horario=horario.cod_horario and grupos2.id_curso=cursos.id_curso;

  
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_aulasd_sin_grupo` ()  BEGIN

 

SELECT DISTINCT edificios.descripcion as name ,
  horario.dia,
  horario.hora_inicio,
  horario.hora_fin,
  aulas.descripcion,
  tipo_de_aula.descripcion2,
  aulas.capacidad,
  aulas_x_disponibilidad.Disponibilidad,
  aulas.cod_aula
  from edificios,horario,aulas,tipo_de_aula,aulas_x_disponibilidad, grupo_x_aula
  WHERE
  edificios.cod_edificio= aulas.cod_edificio and
  aulas.cod_aula= aulas_x_disponibilidad.cod_aula and 
  aulas_x_disponibilidad.cod_horario= horario.cod_horario and 
  aulas.cod_tipo=tipo_de_aula.cod_tipo and
   aulas_x_disponibilidad.cod_aula= aulas.cod_aula and
 aulas_x_disponibilidad.id_disponibilidad NOT in (SELECT DISTINCT grupo_x_aula.cod_aula
                       FROM grupo_x_aula 
                            where aulas.cod_aula = grupo_x_aula.cod_aula);
  
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_carreras` ()  BEGIN
 SELECT descripcion  from carreras;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_codigos_cambio` ()  BEGIN

 
SELECT DISTINCT grupos2.cod_grupo ,cursos.descripcion3,grupos2.id_grupo,horario.dia,horario.hora_inicio,horario.hora_fin,nombre_profesor FROM `grupos2`,horario,cursos WHERE grupos2.id_curso=cursos.id_curso and grupos2.cod_horario=horario.cod_horario;


  
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_cursos` ()  BEGIN
 SELECT DISTINCT  cursos.descripcion3  from cursos;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_directores` ()  BEGIN
 SELECT   personas.correo  from personas where personas.id_rol=5;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_edifios` ()  BEGIN

  SELECT cod_edificio,descripcion,ubicacion,num_aulas,pisos,estado,foto FROM edificios;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_grupos` ()  BEGIN
SELECT DISTINCT grupos2.cod_grupo, cursos.descripcion3, grupos2.id_grupo , horario.dia, horario.hora_inicio, horario.hora_fin, aulas.cod_aula, grupos2.nombre_profesor FROM `aulas`, aulas_x_disponibilidad,grupo_x_aula,grupos2,horario,cursos WHERE aulas.cod_aula=aulas_x_disponibilidad.cod_aula and aulas_x_disponibilidad.id_disponibilidad=grupo_x_aula.cod_aula and grupo_x_aula.cod_grupo= grupos2.cod_grupo and grupos2.cod_horario=horario.cod_horario and grupos2.id_curso=cursos.id_curso;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_grupos_sin_aulas` ()  BEGIN
 SELECT DISTINCT  grupos2.cod_grupo,
 cursos.descripcion3,
    grupos2.id_grupo ,
    horario.dia,
    horario.hora_inicio,
    horario.hora_fin,
    grupos2.nombre_profesor
    FROM cursos,grupos2,horario,grupo_x_aula
    where grupos2.id_curso=cursos.id_curso and 
    grupos2.cod_horario=horario.cod_horario and
    grupos2.cod_grupo NOT IN(SELECT grupo_x_aula.cod_grupo FROM grupo_x_aula);
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `listar_profesores` ()  BEGIN
 SELECT DISTINCT  grupos2.nombre_profesor from grupos2;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `Loop` ()  NO SQL
BEGIN
	etiqueta1:LOOP
    
       SELECT @codigo_aula := cod_aula from aulas 
       where capacidad >= '20' AND cod_tipo != 3 
       and cod_tipo != 4 LIMIT 1;
             
      SELECT @existe = count(*) 
      from 	aulas_x_disponibilidad
      WHERE cod_aula = 1 AND cod_horario = 1;
     SELECT concat('myvar is ', @existe);
   
            LEAVE etiqueta1;  

END LOOP;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_AulasAgregar` (IN `descrip` VARCHAR(100), IN `capa` INT(11), IN `ubi` VARCHAR(100), IN `est` INT(11), IN `fot` VARCHAR(100), IN `edificio` INT(11), IN `tipo` INT(11))  NO SQL
INSERT INTO aulas (descripcion, capacidad, ubicacion, estado, foto, cod_edificio, cod_tipo)VALUES(descrip, capa, ubi, est, fot, edificio, tipo)$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_AulasConsultar` ()  NO SQL
SELECT edificios.descripcion, aulas.descripcion, aulas.capacidad, aulas.ubicacion, tipo_de_aula.descripcion, aulas.estado
FROM aulas, edificios, tipo_de_aula
WHERE aulas.cod_edificio = edificios.cod_edificio and aulas.cod_tipo = tipo_de_aula.cod_tipo$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_AulasEditar` (IN `descrip` VARCHAR(100), IN `est` INT(11))  NO SQL
UPDATE aulas
set estado = est
WHERE descripcion=descrip$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_cambiarestado` (IN `edi` INT)  BEGIN
	DECLARE hola  INT unsigned DEFAULT 1; 
   SELECT  estado into hola from edificios where cod_edificio=edi;
   
   IF (hola>0) THEN
  
UPDATE `edificios` SET `estado`=0 WHERE cod_edificio=edi;

UPDATE `aulas` SET `estado`=0 WHERE aulas.cod_edificio=edi;

  
ELSE

  
UPDATE `edificios` SET `estado`=1 WHERE cod_edificio=edi;

UPDATE `aulas` SET `estado`=1 WHERE aulas.cod_edificio=edi;

  
END IF;


END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_cambiarestadoaula` (IN `aul` INT)  BEGIN
	DECLARE hola2  INT unsigned DEFAULT 1; 
    
   SELECT  estado into hola2 from aulas where cod_aula=aul;
   
   IF (hola2>0) THEN
  


UPDATE `aulas` SET `estado`=0 WHERE cod_aula=aul;

  
ELSE

  
UPDATE `aulas` SET `estado`=1 WHERE cod_aula=aul;

  
END IF;


END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_EdificiosAgregar` (IN `descrip` VARCHAR(100), IN `ubi` VARCHAR(100), IN `num_aula` INT(11), IN `piso` INT(11), IN `estado` INT(11), IN `foto` VARCHAR(100))  NO SQL
INSERT INTO edificios (descripcion, ubicacion, num_aulas, pisos, estado,foto)VALUES(descrip, ubi, num_aula, piso, est,foto)$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_EdificiosConsultar` ()  NO SQL
SELECT descripcion, ubicacion, numero_aulas, pisos, estado from edificios$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_EdificiosEditar` (IN `descrip` VARCHAR(100), IN `est` INT(11))  NO SQL
UPDATE edificios
set estado=est
where descrip= descripcion$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_editar_aula` (IN `cod` INT, IN `des` VARCHAR(100), IN `cap` INT, IN `ubi` VARCHAR(100), IN `es` INT, IN `ed` INT, IN `ti` VARCHAR(100))  BEGIN
DECLARE hola  INT unsigned DEFAULT 1; 
   SELECT  cod_tipo into hola from tipo_de_aula where descripcion2=ti;

UPDATE `aulas` SET `descripcion`=des,`capacidad`=cap,`ubicacion`=ubi,`estado`=es,`foto`='nada.jpg',`cod_edificio`=ed,`cod_tipo`=hola WHERE `cod_aula`=cod;


END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_EnvioCorreo` (IN `rol` INT(11), OUT `email` VARCHAR(100))  NO SQL
set email = (SELECT correo as email
from personas
where id_rol=rol)$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_HorarioAulaConsultar` (IN `aula` INT(11))  NO SQL
SELECT horario.dia, horario.incio, horario.final, aula.estado, cursos.descripcion, personas.nombre+" "+personas.apellidos as 'Profesor', grupos.cod_grupo, grupos.tamaño
FROM aulas, grupos, grupo_x_aula, cursos, horario, personas
WHERE aulas.cod_aula=aula and grupos.id_curso = cursos.id_curso and grupos.id_profesor = personas.id_persona and aulas.cod_aula = grupo_x_aula.cod_aula and grupos.cod_grupo = grupo_x_aula.cod_grupo and grupo.cod_horario = horario.cod_horario$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_HorarioEstudiante` (IN `cedula` INT(100))  NO SQL
SELECT grupos2.descripcion as 'Curso', horario.dia, horario.hora_inicio, horario.hora_fin, grupos2.id_grupo as 'Grupo', aulas.descripcion as 'Aula', grupos2.nombre_profesor as 'Profesor', edificios.descripcion as 'Edificio', edificios.ubicacion AS 'Ubicacion'
FROM grupos2, matricula_estudiante, horario, grupo_x_aula, aulas_x_disponibilidad, aulas, edificios
WHERE matricula_estudiante.id_estudiante = cedula AND
matricula_estudiante.cod_grupo = grupos2.cod_grupo AND
grupos2.cod_horario = horario.cod_horario AND
aulas.cod_aula = aulas_x_disponibilidad.cod_aula AND
aulas_x_disponibilidad.id_disponibilidad = grupo_x_aula.cod_aula AND
grupo_x_aula.cod_grupo = grupos2.cod_grupo AND
aulas.cod_edificio = edificios.cod_edificio$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_HorarioProfe` (IN `id` INT)  NO SQL
select cursos.descripcion3, grupos2.id_grupo ,horario.dia, horario.hora_inicio, horario.hora_fin, aulas.descripcion, edificios.descripcion as 'Edificio', edificios.ubicacion, grupos2.cod_grupo from horario JOIN grupos2 on grupos2.cod_horario=horario.cod_horario JOIN cursos on cursos.id_curso=grupos2.id_curso JOIN grupo_x_aula on grupo_x_aula.cod_grupo = grupos2.cod_grupo JOIN aulas_x_disponibilidad on aulas_x_disponibilidad.id_disponibilidad=grupo_x_aula.cod_aula JOIN aulas on aulas.cod_aula=aulas_x_disponibilidad.cod_aula join edificios on edificios.cod_edificio=aulas.cod_edificio join personas on personas.nombre=grupos2.nombre_profesor where personas.id_persona = id$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_HorariosAula` (IN `aula` INT(11))  NO SQL
SELECT grupos2.descripcion, grupos2.tamaño, grupos2.nombre_profesor, grupos2.id_grupo, aulas_x_disponibilidad.disponibilidad, horario.dia, horario.hora_inicio, horario.hora_fin FROM grupos2, grupo_x_aula, aulas_x_disponibilidad, horario WHERE grupo_x_aula.cod_grupo = grupos2.cod_grupo and aulas_x_disponibilidad.cod_aula=aula and aulas_x_disponibilidad.cod_horario = horario.cod_horario AND aulas_x_disponibilidad.id_disponibilidad = grupo_x_aula.cod_aula$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_insertar_aula` (IN `des` VARCHAR(100), IN `cap` INT, IN `ubi` VARCHAR(100), IN `es` INT, IN `ed` INT, IN `ti` VARCHAR(100))  BEGIN
	DECLARE hola  INT unsigned DEFAULT 1; 
   SELECT  cod_tipo into hola from tipo_de_aula where descripcion2=ti;
  
INSERT INTO `aulas`( `descripcion`, `capacidad`, `ubicacion`, `estado`, `foto`, `cod_edificio`, `cod_tipo`) VALUES (des,cap,ubi,es,'nada.jpg',ed,hola);
  
  
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_insertar_edificio` (IN `des` VARCHAR(100), IN `ubi` VARCHAR(100), IN `num` INT, IN `pi` INT, IN `es` INT, IN `fo` VARCHAR(100))  BEGIN

 
INSERT INTO `edificios`(`descripcion`, `ubicacion`, `num_aulas`, `pisos`, `estado`, `foto`) VALUES (des,ubi,num,pi,es,fo);

  
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_ListarEstudiantesGrupo` (IN `gru` INT)  NO SQL
SELECT personas.id_persona,personas.nombre as 'Nombre' from personas JOIN matricula_estudiante on matricula_estudiante.id_estudiante = personas.id_persona WHERE matricula_estudiante.cod_grupo = gru$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_Login` (IN `id` INT(100), IN `pass` VARCHAR(50), OUT `salida` INT)  BEGIN
    DECLARE rol INT;
    IF(SELECT COUNT(id_persona) from personas 
       where id_persona=id AND contrasena=pass)=1
    THEN
        set rol = (SELECT id_rol from personas
        where id_persona=id and contrasena=pass);
        IF(rol = 1)
        THEN
          -- Profesor
          set salida = 1;
        END IF;
        IF(rol = 2)
        THEN
          -- Estudiante
          set salida = 2;
        END IF;
        IF(rol = 3)
        THEN
          -- Encargado Oferta
          set salida = 3;
        END IF;
        IF(rol = 4)
        THEN
          -- Distribuidor
          set salida = 4;
        END IF;
        IF(rol = 5)
        THEN
          -- Director
          set salida = 5;
        END IF;
    ELSE
        -- login incorrecto
        set salida = 10;
    END IF;
END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_OfertaConsultar` ()  NO SQL
SELECT nombre, fecha_inicio, fecha_fin  from ofertaacademica$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_SolicitudesAgregar` (IN `cod` INT(11), IN `grup` INT(11), IN `cap_extra` INT(11), IN `enviado` INT(11), IN `recibido` INT(11), IN `est` TINYINT(1), IN `titu` VARCHAR(200), IN `asun` VARCHAR(200), IN `sms` VARCHAR(1000))  NO SQL
INSERT INTO solicitudes (cod_solicitud, grupo, aula, user_envio, user_recibo, estado, titulo, asunto, mensaje)
VALUES(cod, grup, cap_extra, enviado, recibido, est, titu, asun, sms)$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_SolicitudesConsultar` (IN `id_director` INT(11))  NO SQL
SELECT *
FROM solicitudes
WHERE user_recibo = id_director$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `sp_SolicitudesEditar` (IN `cod` INT, IN `est` INT, IN `gru` INT, IN `aul` INT)  NO SQL
BEGIN

DECLARE hora  INT unsigned DEFAULT 1;
DECLARE dispo  INT unsigned DEFAULT 1;
DECLARE tamgru  INT unsigned DEFAULT 1;
DECLARE tamaul  INT unsigned DEFAULT 1;

UPDATE solicitudes
set estado=est
where cod_solicitud=cod;


select cod_horario into hora FROM grupos2 WHERE cod_grupo = gru limit 1;
SELECT id_disponibilidad into dispo from aulas_x_disponibilidad WHERE cod_aula= aul and cod_horario = hora limit 1;

SELECT tamaño into tamgru FROM grupos2 WHERE cod_grupo = gru limit 1;
SELECT capacidad into tamaul from aulas where cod_aula = aul limit 1;

INSERT into grupo_x_aula VALUES(dispo,gru);






END$$

CREATE DEFINER=`id15465931_sa`@`%` PROCEDURE `VerCosas` ()  SELECT * from Prueba$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aulas`
--

CREATE TABLE `aulas` (
  `cod_aula` int(100) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `ubicacion` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL,
  `disponibilidad` int(11) DEFAULT NULL,
  `foto` varchar(100) NOT NULL,
  `cod_edificio` int(11) NOT NULL,
  `cod_tipo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `aulas`
--

INSERT INTO `aulas` (`cod_aula`, `descripcion`, `capacidad`, `ubicacion`, `estado`, `disponibilidad`, `foto`, `cod_edificio`, `cod_tipo`) VALUES
(1, 'erer', 434, '2 Piso', 1, 1, 'nada.jpg', 5, 2),
(2, 'Aula 01', 30, '1 Piso', 1, 1, 'nada.jpg', 6, 4),
(3, 'Aula 01 Editado', 30, '1 Piso', 1, 1, 'nada.jpg', 7, 1),
(4, 'Aula 02', 50, '1 Piso', 1, 1, 'nada.jpg', 7, 1),
(5, 'Aula 03', 50, '1 Piso', 1, 1, 'nada.jpg', 7, 1),
(6, 'Laboratorio 01', 30, '1 Piso', 1, 1, 'nada.jpg', 7, 2),
(7, 'Laboratorio 02', 30, '1 Piso', 1, 1, 'nada.jpg', 7, 2),
(8, 'Laboratorio 03', 30, '1 Piso', 1, 1, 'nada.jpg', 7, 2),
(9, 'Aula 01', 20, '1 Piso', 1, 1, 'nada.jpg', 8, 1),
(10, 'Fotocopiadora', 0, '1 Piso', 1, 1, 'nada.jpg', 9, 4),
(11, 'Laboratorio EL', 45, '1 Piso', 1, 1, 'nada.jpg', 9, 2),
(12, 'Laboratorio EL', 45, '1 Piso', 1, 1, 'nada.jpg', 9, 2),
(13, 'Dirección Académica', 0, '1 Piso', 1, 1, 'nada.jpg', 9, 3),
(14, 'Dirección Electrónica', 0, '1 Piso', 1, 1, 'nada.jpg', 9, 3),
(15, 'Aula 01', 20, '1 Piso', 1, 1, 'nada.jpg', 9, 1),
(16, 'Aula 02', 20, '1 Piso', 1, 1, 'nada.jpg', 9, 1),
(17, 'Aula 03', 20, '1 Piso', 1, 1, 'nada.jpg', 9, 1),
(18, 'Aula 04', 20, '1 Piso', 1, 1, 'nada.jpg', 9, 1),
(19, 'Aula 05', 20, '1 Piso', 1, 1, 'nada.jpg', 9, 1),
(20, 'Aula 06', 20, '1 Piso', 1, 1, 'nada.jpg', 9, 1),
(21, 'Aula DECAT 01', 35, '1 Piso', 1, 1, 'nada.jpg', 10, 1),
(22, 'Aula DECAT 02', 35, '1 Piso', 1, 1, 'nada.jpg', 10, 1),
(23, 'Aula DECAT 03', 35, '1 Piso', 1, 1, 'nada.jpg', 10, 1),
(24, 'Aula DECAT 04', 35, '1 Piso', 1, 1, 'nada.jpg', 10, 1),
(25, 'Aula DECAT 05', 35, '1 Piso', 1, 1, 'nada.jpg', 10, 1),
(26, 'Aula DECAT 06', 35, '1 Piso', 1, 1, 'nada.jpg', 10, 1),
(27, 'Aula 01', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(28, 'Aula 02', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(29, 'Aula 03', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(30, 'Aula 04', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(31, 'Aula 05', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(32, 'Aula 06', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(33, 'Aula 07', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(34, 'Aula 08', 35, '1 Piso', 1, 1, 'nada.jpg', 11, 1),
(35, 'Aula 09', 35, '2 Piso', 1, 1, 'nada.jpg', 11, 1),
(36, 'Aula 10', 35, '2 Piso', 1, 1, 'nada.jpg', 11, 1),
(37, 'Aula 11', 35, '2 Piso', 1, 1, 'nada.jpg', 11, 1),
(38, 'Aula 12', 35, '2 Piso', 1, 1, 'nada.jpg', 11, 1),
(39, 'Lab Programación A', 45, '2 Piso', 1, 1, 'nada.jpg', 11, 2),
(40, 'Lab Programación B', 45, '2 Piso', 1, 1, 'nada.jpg', 11, 2),
(41, 'DECAT (2nd planta)', 0, '2 Piso', 1, 1, 'nada.jpg', 11, 1),
(42, 'JV Aula 01', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(43, 'JV Aula 02', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(44, 'JV Aula 03', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(45, 'JV Aula 04', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(46, 'JV Aula 05', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(47, 'JV Aula 06', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(48, 'JV Aula 07', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(49, 'JV Aula 08', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(50, 'JV Aula 09', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(51, 'JV Aula 10', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(52, 'JV Aula 11', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(53, 'JV Aula 12', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(54, 'JV Aula 13', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(55, 'JV Aula 14', 35, '1 Piso', 1, 1, 'nada.jpg', 12, 1),
(56, 'Aula 01 pequeña', 18, '1 Piso', 1, 1, 'nada.jpg', 13, 1),
(57, 'Aula 02 pequeña', 18, '1 Piso', 1, 1, 'nada.jpg', 13, 1),
(58, 'Aula 03 pequeña', 18, '1 Piso', 1, 1, 'nada.jpg', 13, 1),
(59, 'Aula 04 pequeña', 18, '1 Piso', 1, 1, 'nada.jpg', 13, 1),
(60, 'Aula 01 mediana', 20, '1 Piso', 1, 1, 'nada.jpg', 14, 1),
(61, 'Aula 02 mediana', 20, '1 Piso', 1, 1, 'nada.jpg', 14, 1),
(62, 'Aula 03 mediana', 20, '1 Piso', 1, 1, 'nada.jpg', 14, 1),
(63, 'Aula 04 mediana', 20, '1 Piso', 1, 1, 'nada.jpg', 14, 1),
(64, 'Lab Idiomas 01', 25, '1 Piso', 1, 1, 'nada.jpg', 15, 2),
(65, 'Lab Idiomas 02', 25, '1 Piso', 1, 1, 'nada.jpg', 15, 2),
(66, 'Lab Idiomas 03', 25, '1 Piso', 1, 1, 'nada.jpg', 15, 2),
(72, '4', 14, '1 Piso', 1, NULL, 'nada.jpg', 7, 2),
(73, 'Aula01', 25, '2 Piso', 1, NULL, 'nada.jpg', 19, 2),
(74, 'Aula02', 25, '2 Piso', 1, NULL, 'nada.jpg', 19, 2),
(75, 'Laboratorio B', 15, '1 Piso', 1, NULL, 'nada.jpg', 20, 2),
(76, 'ui', 2, '1 Piso', 1, NULL, 'nada.jpg', 5, 2),
(77, '44', 3, '1 Piso', 1, NULL, 'nada.jpg', 5, 3),
(78, 's', 2, '1 Piso', 1, NULL, 'nada.jpg', 5, 2),
(79, 'Aula01 Prueba', 18, '1 Piso', 0, NULL, 'nada.jpg', 36, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aulas_x_disponibilidad`
--

CREATE TABLE `aulas_x_disponibilidad` (
  `id_disponibilidad` int(100) NOT NULL,
  `cod_aula` int(100) NOT NULL,
  `cod_horario` int(100) DEFAULT NULL,
  `Disponibilidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `aulas_x_disponibilidad`
--

INSERT INTO `aulas_x_disponibilidad` (`id_disponibilidad`, `cod_aula`, `cod_horario`, `Disponibilidad`) VALUES
(10, 3, 19, 2),
(11, 3, 20, 2),
(12, 3, 21, 2),
(13, 3, 22, 2),
(14, 4, 22, 2),
(15, 3, 23, 2),
(16, 4, 21, 2),
(17, 5, 21, 2),
(18, 3, 24, 2),
(19, 3, 25, 2),
(20, 3, 26, 2),
(21, 3, 27, 2),
(22, 3, 28, 2),
(23, 3, 29, 2),
(24, 3, 30, 2),
(25, 4, 20, 2),
(26, 5, 20, 2),
(27, 3, 31, 2),
(28, 21, 21, 2),
(29, 3, 32, 2),
(30, 4, 31, 2),
(31, 5, 31, 2),
(32, 3, 33, 2),
(33, 21, 20, 2),
(34, 22, 21, 2),
(35, 5, 22, 2),
(36, 4, 23, 2),
(37, 4, 19, 2),
(38, 5, 19, 2),
(39, 3, 34, 2),
(40, 4, 28, 2),
(41, 4, 26, 2),
(42, 4, 25, 2),
(43, 3, 35, 2),
(44, 4, 29, 2),
(45, 4, 32, 2),
(46, 4, 33, 2),
(47, 4, 30, 2),
(48, 9, 31, 2),
(49, 15, 31, 2),
(50, 21, 22, 2),
(51, 5, 23, 2),
(52, 21, 23, 2),
(53, 22, 20, 2),
(54, 23, 21, 2),
(55, 21, 19, 2),
(56, 5, 28, 2),
(57, 23, 20, 2),
(58, 5, 26, 2),
(59, 5, 25, 2),
(60, 21, 31, 2),
(61, 22, 31, 2),
(62, 5, 30, 2),
(63, 5, 29, 2),
(64, 5, 32, 2),
(65, 5, 33, 2),
(66, 24, 21, 2),
(67, 22, 19, 1),
(68, 22, 22, 2),
(69, 24, 20, 2),
(70, 22, 23, 2),
(71, 23, 19, 2),
(72, 4, 27, 2),
(73, 21, 25, 2),
(74, 21, 32, 2),
(75, 21, 26, 2),
(76, 21, 30, 2),
(77, 23, 31, 2),
(78, 24, 19, 2),
(79, 25, 21, 2),
(80, 23, 22, 2),
(81, 9, 23, 2),
(82, 9, 20, 2),
(83, 22, 25, 2),
(84, 5, 27, 2),
(85, 4, 34, 2),
(86, 22, 32, 2),
(87, 21, 29, 2),
(88, 24, 22, 2),
(89, 26, 21, 2),
(90, 25, 19, 2),
(91, 4, 35, 2),
(92, 23, 23, 2),
(93, 25, 20, 2),
(94, 9, 22, 2),
(95, 3, 36, 2),
(96, 4, 36, 2),
(97, 5, 36, 2),
(98, 9, 36, 2),
(99, 15, 36, 2),
(100, 16, 36, 2),
(101, 15, 23, 2),
(102, 5, 34, 2),
(103, 21, 28, 2),
(104, 23, 25, 2),
(105, 22, 26, 2),
(106, 1, 19, 2),
(107, 1, 20, 2),
(108, 1, 21, 2),
(109, 1, 22, 2),
(110, 6, 22, 2),
(111, 1, 23, 2),
(112, 6, 21, 2),
(113, 7, 21, 2),
(114, 1, 24, 2),
(115, 1, 25, 2),
(116, 1, 26, 2),
(117, 1, 27, 2),
(118, 1, 28, 2),
(119, 1, 29, 2),
(120, 1, 30, 2),
(121, 11, 20, 2),
(122, 12, 20, 2),
(123, 1, 31, 2),
(124, 8, 21, 2),
(125, 1, 32, 2),
(126, 6, 31, 2),
(127, 7, 31, 2),
(128, 1, 33, 2),
(129, 6, 20, 2),
(130, 11, 21, 2),
(131, 7, 22, 2),
(132, 6, 23, 2),
(133, 3, 19, 2),
(134, 4, 19, 2),
(135, 1, 34, 2),
(136, 6, 28, 2),
(137, 6, 26, 2),
(138, 6, 25, 2),
(139, 1, 35, 2),
(140, 6, 29, 2),
(141, 6, 32, 2),
(142, 6, 33, 2),
(143, 6, 30, 2),
(144, 8, 31, 2),
(145, 11, 31, 2),
(146, 8, 22, 2),
(147, 7, 23, 2),
(148, 8, 23, 2),
(149, 7, 20, 2),
(150, 12, 21, 2),
(151, 5, 19, 2),
(152, 7, 28, 2),
(153, 8, 20, 2),
(154, 7, 26, 2),
(155, 7, 25, 2),
(156, 12, 31, 2),
(157, 24, 31, 2),
(158, 7, 30, 2),
(159, 7, 29, 2),
(160, 7, 32, 2),
(161, 7, 33, 2),
(162, 27, 21, 2),
(163, 6, 19, 2),
(164, 11, 22, 2),
(165, 26, 20, 2),
(166, 11, 23, 2),
(167, 7, 19, 1),
(168, 6, 27, 2),
(169, 8, 25, 2),
(170, 8, 32, 2),
(171, 8, 26, 2),
(172, 8, 30, 2),
(173, 25, 31, 2),
(174, 8, 19, 2),
(175, 28, 21, 2),
(176, 12, 22, 2),
(177, 12, 23, 2),
(178, 15, 20, 2),
(179, 11, 25, 2),
(180, 7, 27, 2),
(181, 6, 34, 2),
(182, 11, 32, 2),
(183, 8, 29, 2),
(184, 25, 22, 2),
(185, 29, 21, 2),
(186, 11, 19, 2),
(187, 5, 35, 2),
(188, 24, 23, 2),
(189, 27, 20, 2),
(190, 15, 22, 2),
(191, 1, 36, 2),
(192, 6, 36, 2),
(193, 7, 36, 2),
(194, 8, 36, 2),
(195, 11, 36, 2),
(196, 12, 36, 2),
(197, 16, 23, 2),
(198, 7, 34, 2),
(199, 8, 28, 2),
(200, 12, 25, 2),
(201, 11, 26, 2),
(202, 12, 19, 2),
(203, 3, 20, 2),
(204, 30, 21, 2),
(205, 16, 22, 2),
(206, 17, 22, 2),
(207, 17, 23, 2),
(208, 9, 21, 2),
(209, 15, 21, 2),
(210, 4, 24, 2),
(211, 24, 25, 2),
(212, 12, 26, 2),
(213, 8, 27, 2),
(214, 9, 28, 2),
(215, 11, 29, 2),
(216, 11, 30, 2),
(217, 28, 20, 2),
(218, 29, 20, 2),
(219, 26, 31, 2),
(220, 31, 21, 2),
(221, 9, 32, 2),
(222, 15, 31, 2),
(223, 16, 31, 2),
(224, 8, 33, 2),
(225, 30, 20, 2),
(226, 32, 21, 2),
(227, 26, 22, 2),
(228, 25, 23, 2),
(229, 6, 19, 2),
(230, 9, 19, 2),
(231, 8, 34, 2),
(232, 11, 28, 2),
(233, 23, 26, 2),
(234, 25, 25, 2),
(235, 6, 35, 2),
(236, 12, 29, 2),
(237, 12, 32, 2),
(238, 11, 33, 2),
(239, 12, 30, 2),
(240, 17, 31, 2),
(241, 18, 31, 2),
(242, 27, 22, 2),
(243, 26, 23, 2),
(244, 27, 23, 2),
(245, 31, 20, 2),
(246, 33, 21, 2),
(247, 21, 19, 2),
(248, 12, 28, 2),
(249, 32, 20, 2),
(250, 24, 26, 2),
(251, 26, 25, 2),
(252, 27, 31, 2),
(253, 28, 31, 2),
(254, 22, 30, 2),
(255, 22, 29, 2),
(256, 23, 32, 2),
(257, 12, 33, 2),
(258, 34, 21, 2),
(259, 26, 19, 2),
(260, 28, 22, 2),
(261, 33, 20, 2),
(262, 28, 23, 2),
(263, 27, 19, 2),
(264, 11, 27, 2),
(265, 27, 25, 2),
(266, 24, 32, 2),
(267, 25, 26, 2),
(268, 23, 30, 2),
(269, 29, 31, 2),
(270, 28, 19, 2),
(271, 35, 21, 2),
(272, 29, 22, 2),
(273, 18, 23, 2),
(274, 16, 20, 2),
(275, 28, 25, 2),
(276, 12, 27, 2),
(277, 11, 34, 2),
(278, 25, 32, 2),
(279, 23, 29, 2),
(280, 30, 22, 2),
(281, 36, 21, 2),
(282, 29, 19, 2),
(283, 7, 35, 2),
(284, 29, 23, 2),
(285, 34, 20, 2),
(286, 18, 22, 2),
(287, 17, 36, 2),
(288, 18, 36, 2),
(289, 19, 36, 2),
(290, 20, 36, 2),
(291, 21, 36, 2),
(292, 22, 36, 2),
(293, 19, 23, 2),
(294, 12, 34, 2),
(295, 22, 28, 2),
(296, 29, 25, 2),
(297, 26, 26, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carreras`
--

CREATE TABLE `carreras` (
  `id_carrera` int(100) NOT NULL,
  `Cod_Unico` varchar(100) DEFAULT NULL,
  `descripcion` varchar(100) NOT NULL,
  `id_director_carrera` int(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `carreras`
--

INSERT INTO `carreras` (`id_carrera`, `Cod_Unico`, `descripcion`, `id_director_carrera`) VALUES
(1, 'TI', ' DIPLOMADO TECNOLOGÍAS DE LA INFORMACIÓN', 305550555),
(2, NULL, 'Dirección y Administración de Empresas', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos`
--

CREATE TABLE `cursos` (
  `id_curso` int(100) NOT NULL,
  `CodUnico` varchar(20) NOT NULL,
  `descripcion3` varchar(100) NOT NULL,
  `id_carrera` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cursos`
--

INSERT INTO `cursos` (`id_curso`, `CodUnico`, `descripcion3`, `id_carrera`) VALUES
(1, 'TI-126', 'Ingles Conversacional I', 1),
(2, 'TI-136', 'Ingles Conversacional II', 1),
(3, 'TI-145', 'Contabilidad General', 1),
(4, 'TI-148', 'Ingles Tecnico', 1),
(5, 'TI-111', 'Fundamentos de Programacion', 1),
(6, 'TI-112', 'Fundamentos de Informatica', 1),
(7, 'TI-113', 'Soporte Tecnico', 1),
(8, 'TI-114', 'Matematica I', 1),
(9, 'TI-115', 'Comunicacion I', 1),
(10, 'TI-122', 'Metodos y Tecnicas de Investigacion', 1),
(11, 'TI-124', 'Matematica II', 1),
(12, 'TI-125', 'Comunicacion II', 1),
(13, 'TI-121', 'Programacion I', 1),
(14, 'TI-131', 'Programacion II', 1),
(15, 'TI-132', 'Estructura de Datos', 1),
(16, 'TI-135', 'Telematica y Redes', 1),
(17, 'TI-141', 'Programación III', 1),
(18, 'TI-142', 'Fundamentos de Bases de Datos', 1),
(19, 'TI-144', 'Ingeniería de Software I', 1),
(20, 'TI-151', 'Programacion IV', 1),
(21, 'TI-152', 'Administracion Bases de Datos', 1),
(22, 'TI-153', 'Administracion Sistemas Operativos de Red', 1),
(23, 'TI-154', 'Ingenieria de Software II', 1),
(24, 'TI-155', 'Emprendedores', 1),
(25, 'TI-161', 'Programacion V', 1),
(26, 'TI-162', 'Administracion y Programacion de Sitios Web', 1),
(27, 'TI-163', 'Arquitectura y Sistemas Operativos', 1),
(28, 'AA-101', 'Comunicación Oral y Escrita', 2),
(29, 'AC-101', 'Contabilidad General ', 2),
(30, 'AE-101', 'Matemática p/Administrar Emp.', 2),
(31, 'AF-101', 'Comp. p/Administrar Emp.', 2),
(32, 'AM-101', 'Inglés p/Negocios', 2),
(33, 'AA-202', 'Administración General 1', 2),
(34, 'AC-202', 'Contabilidad Intermedia', 2),
(35, 'AE-202', 'Estadística Descriptiva', 2),
(36, 'AF-2021', 'Legislación Empresarial', 2),
(37, 'AM-202', 'Inglés para Negocios II', 2),
(38, 'AA-303', 'Administración General II', 2),
(39, 'AC-303', 'Contabilidad Avanzada', 2),
(40, 'AE-303', 'Estadística Inferencial', 2),
(41, 'AF-303', 'Matemática Financiera', 2),
(42, 'AM-3031', 'Legislación Tributaria ', 2),
(43, 'AA-404', 'Metodología de la Investigación', 2),
(44, 'AC-404', 'Contabilidad Costos 1', 2),
(45, 'AE-404', 'Microeconomía', 2),
(46, 'AF-404', 'Finanzas 1', 2),
(47, 'AM-404', 'Gerencia de Mercadotecnia I ', 2),
(48, 'AA-505', 'Legislaciòn Laboral', 2),
(49, 'AC-505', 'Contabilidad Costos II', 2),
(50, 'AE-505', 'Macroeconomía                           ', 2),
(51, 'AF-505', 'Finanzas II', 2),
(52, 'AM-505', 'Gerencia de Mercadotecnia II                         ', 2),
(53, 'AA-606', 'Adm. de Rec. Humanos', 2),
(54, 'AC-606', 'Auditoría General', 2),
(55, 'AE-606', 'Producción y Estrategia               ', 2),
(56, 'AF-606', 'Administración de Proyectos', 2),
(57, 'AM-606', 'Gerencia y Estrategia                  ', 2),
(58, 'DE-001', 'Práctica Supervisada', 2),
(59, 'DE-003', 'Proyecto de Graduación', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `edificios`
--

CREATE TABLE `edificios` (
  `cod_edificio` int(100) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `ubicacion` varchar(100) NOT NULL,
  `num_aulas` int(11) NOT NULL,
  `pisos` int(11) NOT NULL,
  `estado` int(11) NOT NULL,
  `foto` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `edificios`
--

INSERT INTO `edificios` (`cod_edificio`, `descripcion`, `ubicacion`, `num_aulas`, `pisos`, `estado`, `foto`) VALUES
(5, 'DECAT (2da planta)', 'Frente a las oficinas de Administración', 22, 2, 1, 'decat.jpg'),
(6, 'Biblioteca', 'Al norte de el edificio DECAT', 1, 1, 1, 'biblio.jpg'),
(7, 'Mecánica Dental', 'Al lado izquierdo de la Biblioteca', 6, 1, 1, 'jiji.jpg'),
(8, 'Polígono', 'Detrás de los laboratorios de idiomas', 0, 1, 1, 'poli.jpg'),
(9, 'Casco', 'Al lado derecho de las aulas del DECAT', 11, 1, 1, 'cono1.jpg'),
(10, 'Aulas DECAT', 'Detrás del area de parqueo', 6, 1, 1, 'decat.jpg'),
(11, 'Edificio de Aulas', 'Frente al Edificio de Administración', 16, 2, 1, 'nose.jpg'),
(12, 'Jorge Volio', 'Contiguo a las aulas del DECAT', 14, 1, 1, 'aulas.jpg'),
(13, 'Edificio de Aulas pequeñas', 'Junto a la sala de profesores', 4, 1, 1, 'jiki.jpg'),
(14, 'Edificio de Aulas medianas', 'Junto al CETE', 4, 1, 1, 'jija.jpg'),
(15, 'Laboratorios Idiomas', 'Frente al Poligono', 4, 1, 1, 'pasilo.jpg'),
(16, 'Laboratorios', 'Contiguo a las aulas medianas', 4, 1, 1, 'sigue.jpg'),
(19, 'Decat', 'Frente a fotocopiadora', 25, 2, 1, 'img_home.jpg'),
(20, 'Decat', 'Frente a la fotocopiadora', 25, 2, 1, 'cono1.jpg'),
(36, 'DecatPrueba', 'Frente biblioteca', 10, 1, 0, 'jiki.jpg'),
(37, 'Decat3Prueba', 'Frente Biblioteca Prueba', 10, 1, 1, 'jiki.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupos2`
--

CREATE TABLE `grupos2` (
  `cod_grupo` int(100) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `tamaño` varchar(11) NOT NULL,
  `cod_horario` int(11) DEFAULT NULL,
  `nombre_profesor` varchar(100) NOT NULL,
  `id_curso` int(11) NOT NULL,
  `id_grupo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `grupos2`
--

INSERT INTO `grupos2` (`cod_grupo`, `descripcion`, `tamaño`, `cod_horario`, `nombre_profesor`, `id_curso`, `id_grupo`) VALUES
(229, 'Comunicación Oral y Escrita', '35', 19, 'Quirós Navarro Dagoberto ', 28, '1'),
(230, 'Contabilidad General ', '35', 20, 'Monge Chaves Alexander', 29, '1'),
(231, 'Matemática p/Administrar Emp.', '30', 21, 'Brenes Catalán Mauricio', 30, '1'),
(232, 'Comp. p/Administrar Emp.', '20', 22, 'Rafael Ramirez Pacheco', 31, '1'),
(233, 'Comp. p/Administrar Emp.', '20', 22, 'Segura Mora Katya', 31, '4'),
(234, 'Inglés p/Negocios', '20', 23, 'Campos Arrieta Silvia', 32, '1'),
(235, 'Inglés p/Negocios', '20', 21, 'Martínez Solano Lucrecia', 32, '4'),
(236, 'Inglés p/Negocios', '20', 21, 'Zúñiga Jiménez Rosa Ileana', 32, '5'),
(237, 'Comunicación Oral y Escrita', '35', 24, 'Garita Lizano Nelly', 28, '2'),
(238, 'Contabilidad General ', '35', 25, 'Segura Abarca Gilbert', 29, '2'),
(239, 'Matemática p/Administrar Emp.', '30', 26, 'Acosta Rivera Pablo', 30, '2'),
(240, 'Comp. p/Administrar Emp.', '20', 27, 'Agüero Montero Rolando', 31, '2'),
(241, 'Inglés p/Negocios', '20', 28, 'Campos Arrieta Silvia', 32, '2'),
(242, 'Comunicación Oral y Escrita', '35', 29, 'Garita Lizano Nelly', 28, '3'),
(243, 'Contabilidad General ', '35', 30, 'Aguirre Chinchilla Andrés', 29, '3'),
(244, 'Contabilidad General ', '35', 20, 'Araya Leandro Alfredo', 29, '4'),
(245, 'Contabilidad General ', '35', 20, 'Quirós Barahona Maureen', 29, '5'),
(246, 'Matemática p/Administrar Emp.', '30', 31, 'Acosta Rivera Pablo', 30, '3'),
(247, 'Matemática p/Administrar Emp.', '30', 21, 'Hernández Cespedes Marco', 30, '4'),
(248, 'Comp. p/Administrar Emp.', '20', 32, 'Abarca Cerdas Damaris', 31, '3'),
(249, 'Comp. p/Administrar Emp.', '20', 31, 'Abarca Cerdas Damaris', 31, '5'),
(250, 'Comp. p/Administrar Emp.', '20', 31, 'Agüero Montero Rolando', 31, '6'),
(251, 'Inglés p/Negocios', '20', 33, 'Martínez Solano Lucrecia', 32, '3'),
(252, 'Administración General 1', '30', 20, 'Orozco Coto Luis Roberto', 33, '1'),
(253, 'Contabilidad Intermedia', '30', 21, 'Jimenez Sorio Walter', 34, '1'),
(254, 'Estadística Descriptiva', '30', 22, 'Acosta Rivera Pablo', 35, '1'),
(255, 'Legislación Empresarial', '30', 23, 'Collado Parrales Marvin', 36, '1'),
(256, 'Inglés para Negocios II', '20', 19, 'Monge Solano Anabelle', 37, '1'),
(257, 'Inglés para Negocios II', '20', 19, 'Brenes Piedra Geovanny', 37, '5'),
(258, 'Administración General 1', '30', 34, 'Orozco Coto Luis Roberto', 33, '2'),
(259, 'Contabilidad Intermedia', '30', 28, 'Calderón Pizarro Ana', 34, '2'),
(260, 'Estadística Descriptiva', '30', 26, 'Leitón Sancho Nathalie', 35, '2'),
(261, 'Legislación Empresarial ', '30', 25, 'Araya Cespedes Maria del Pilar', 36, '2'),
(262, 'Inglés para Negocios II', '20', 35, 'Leiva Picado Rita', 37, '2'),
(263, 'Administración General 1', '30', 29, 'Pereira Carvajal Adriana', 33, '3'),
(264, 'Contabilidad Intermedia ', '30', 32, 'Calderón Pizarro Ana', 34, '3'),
(265, 'Estadística Descriptiva', '30', 33, 'Leitón Sancho Nathalie', 35, '3'),
(266, 'Legislación Empresarial', '30', 30, 'Alpizar Picado Erick', 36, '3'),
(267, 'Inglés para Negocios II', '20', 31, 'Leiva Picado Rita', 37, '3'),
(268, 'Inglés para Negocios II', '20', 31, 'Campos Arrieta Silvia', 37, '4'),
(269, 'Administración General II', '30', 22, 'CHINCHILLA CERVANTES CARLOS', 38, '1'),
(270, 'Contabilidad Avanzada', '30', 23, 'Quirós Barahona Maureen', 39, '1'),
(271, 'Contabilidad Avanzada', '30', 23, 'Jiménez Sorio Walter', 39, '3'),
(272, 'Estadística Inferencial', '30', 20, 'Brenes Catalán Mauricio', 40, '1'),
(273, 'Matemática Financiera', '30', 21, 'Aguirre Chinchilla Andrés', 41, '1'),
(274, 'Legislación Tributaria ', '30', 19, 'Araya Cespedes Maria del Pilar', 42, '1'),
(275, 'Administración General II', '30', 28, 'Villalta Loaiza Cristina', 38, '2'),
(276, 'Estadística Inferencial', '30', 20, 'Leitón Sancho Nathalie', 40, '4'),
(277, 'Estadìstica Inferencial           ', '30', 26, 'Hernandez Cespedes Marco', 40, '2'),
(278, 'Matemática Financiera                 ', '30', 25, 'Jiménez Sorio Walter', 41, '2'),
(279, 'Legislación Tributaria ', '30', 31, 'Alpizar Picado Erick', 42, '2'),
(280, 'Administración General II', '30', 31, 'Hidalgo Sáenz Róger', 38, '3'),
(281, 'Contabilidad Avanzada', '30', 30, 'Jiménez Sorio Walter', 39, '2'),
(282, 'Estadìstica Inferencial           ', '30', 29, 'Leitón Sancho Nathalie', 40, '3'),
(283, 'Matemática Financiera                 ', '30', 32, 'Hernandez Cespedes Marco', 41, '3'),
(284, 'Legislación Tributaria ', '30', 33, 'Alpizar Picado Erick', 42, '3'),
(285, 'Metodología de la Investigación', '27', 21, 'Cortés Morales Laura', 43, '1'),
(286, 'Contabilidad Costos 1', '30', 19, 'Quirós Barahona Maureen', 44, '1'),
(287, 'Microeconomía', '30', 22, 'SOLANO CORRELLA RODOLFO', 45, '1'),
(288, 'Finanzas 1', '30', 20, 'Meza Cervantes Alberto', 46, '1'),
(289, 'Gerencia de Mercadotecnia I ', '30', 23, 'Castro Marco', 47, '1'),
(290, 'Contabilidad Costos 1', '30', 19, 'Vargas Mora Milton', 44, '3'),
(291, 'Contabilidad Costos 1', '30', 27, 'Aguilar Solano Sergio', 44, '2'),
(292, 'Finanzas 1', '30', 25, 'Campos Segura Mercedes', 46, '2'),
(293, 'Metodología de la Investigación', '30', 32, 'Orozco Coto Luis Roberto', 43, '2'),
(294, 'Microeconomía', '30', 26, 'SOLANO CORRELLA RODOLFO', 45, '3'),
(295, 'Microeconomía', '30', 30, 'SOLANO CORRELLA RODOLFO', 45, '2'),
(296, 'Gerencia de Mercadotecnia I', '30', 31, 'Malavassi Alvarez Sergio', 47, '2'),
(297, 'Legislaciòn Laboral', '30', 19, 'Collado Parrales Marvin', 48, '1'),
(298, 'Contabilidad Costos II', '30', 21, 'Quirós Barahona Maureen', 49, '1'),
(299, 'Macroeconomía                           ', '30', 22, 'Hernández Palma Eugenio', 50, '1'),
(300, 'Finanzas II', '13', 23, 'Hernández Camacho Alexander', 51, '1'),
(301, 'Gerencia de Mercadotecnia II                         ', '14', 20, 'Cortés Morales Laura', 52, '1'),
(302, 'Contabilidad Costos II', '30', 25, 'Vargas Mora Milton', 49, '2'),
(303, 'Macroeconomía                           ', '30', 27, 'Moya Córdoba Adrián', 50, '2'),
(304, 'Gerencia de Mercadotecnia II                         ', '25', 34, 'Espinoza González J.Alfonso', 52, '2'),
(305, 'Legislaciòn Laboral', '30', 32, 'Araya Céspedes Ma. del Pilar', 48, '3'),
(306, 'Finanzas II', '23', 29, 'Campos Segura Mercedes', 51, '2'),
(307, 'Adm. de Rec. Humanos', '30', 22, 'Hidalgo Sáenz Róger', 53, '1'),
(308, 'Auditoría General', '30', 21, 'Monge Chaves Alexander', 54, '1'),
(309, 'Producción y Estrategia               ', '30', 19, 'Brenes Catalán Mauricio', 55, '1'),
(310, 'Producción y Estrategia               ', '30', 35, 'Brenes Morales Orlando', 55, '2'),
(311, 'Administración de Proyectos', '30', 23, 'Alvarez Castro Adriana', 56, '1'),
(312, 'Gerencia y Estrategia                  ', '30', 20, 'Hernández Palma Eugenio', 57, '1'),
(313, 'Práctica Supervisada', '6', 22, 'Espinoza González J.Alfonso', 58, '1'),
(314, 'Práctica Supervisada', '6', 36, 'Espinoza González J.Alfonso', 58, '2'),
(315, 'Práctica Supervisada', '6', 36, 'Espinoza González J.Alfonso', 58, '3'),
(316, 'Práctica Supervisada', '6', 36, 'Moya Córdoba Adrián', 58, '4'),
(317, 'Práctica Supervisada', '6', 36, 'Quiros Brenes Paulo', 58, '5'),
(318, 'Práctica Supervisada', '6', 36, 'Quiros Brenes Paulo', 58, '6'),
(319, 'Práctica Supervisada', '6', 36, 'Hidalgo Montoya Guiselle', 58, '7'),
(320, 'Proyecto de Graduación', '13', 23, 'Villalta Loaiza Cristina', 59, '1'),
(321, 'Adm. de Rec. Humanos', '30', 34, 'Aguilar Solano Sergio', 53, '2'),
(322, 'Auditoría General', '30', 28, 'Aguilar Solano Sergio', 54, '2'),
(323, 'Administración de Proyectos', '30', 25, 'Hidalgo Montoya Guiselle', 56, '2'),
(324, 'Gerencia y Estrategia                  ', '30', 26, 'Espinoza González J.Alfonso', 57, '2'),
(327, 'Ingles', '28', 24, 'Quirós Navarro Dagoberto ', 1, '1'),
(328, 'Ingles2', '28', 24, 'Monge Chaves Alexander', 2, '2'),
(329, 'jiji', '4', 24, 'Quirós Navarro Dagoberto ', 4, '2'),
(330, 'Ingles2', '2', 21, 'Monge Chaves Alexander', 4, '1'),
(331, 'Comunicación Oral y Escrita', '35', 19, 'Quirós Navarro Dagoberto ', 28, '1'),
(332, 'Contabilidad General ', '35', 20, 'Monge Chaves Alexander', 29, '1'),
(333, 'Matemática p/Administrar Emp.', '30', 21, 'Brenes Catalán Mauricio', 30, '1'),
(334, 'Comp. p/Administrar Emp.', '20', 22, 'Rafael Ramirez Pacheco', 31, '1'),
(335, 'Comp. p/Administrar Emp.', '20', 22, 'Segura Mora Katya', 31, '4'),
(336, 'Inglés p/Negocios', '20', 23, 'Campos Arrieta Silvia', 32, '1'),
(337, 'Inglés p/Negocios', '20', 21, 'Martínez Solano Lucrecia', 32, '4'),
(338, 'Inglés p/Negocios', '20', 21, 'Zúñiga Jiménez Rosa Ileana', 32, '5'),
(339, 'Comunicación Oral y Escrita', '35', 24, 'Garita Lizano Nelly', 28, '2'),
(340, 'Contabilidad General ', '35', 25, 'Segura Abarca Gilbert', 29, '2'),
(341, 'Matemática p/Administrar Emp.', '30', 26, 'Acosta Rivera Pablo', 30, '2'),
(342, 'Comp. p/Administrar Emp.', '20', 27, 'Agüero Montero Rolando', 31, '2'),
(343, 'Inglés p/Negocios', '20', 28, 'Campos Arrieta Silvia', 32, '2'),
(344, 'Comunicación Oral y Escrita', '35', 29, 'Garita Lizano Nelly', 28, '3'),
(345, 'Contabilidad General ', '35', 30, 'Aguirre Chinchilla Andrés', 29, '3'),
(346, 'Contabilidad General ', '35', 20, 'Araya Leandro Alfredo', 29, '4'),
(347, 'Contabilidad General ', '35', 20, 'Quirós Barahona Maureen', 29, '5'),
(348, 'Matemática p/Administrar Emp.', '30', 31, 'Acosta Rivera Pablo', 30, '3'),
(349, 'Matemática p/Administrar Emp.', '30', 21, 'Hernández Cespedes Marco', 30, '4'),
(350, 'Comp. p/Administrar Emp.', '20', 32, 'Abarca Cerdas Damaris', 31, '3'),
(351, 'Comp. p/Administrar Emp.', '20', 31, 'Abarca Cerdas Damaris', 31, '5'),
(352, 'Comp. p/Administrar Emp.', '20', 31, 'Agüero Montero Rolando', 31, '6'),
(353, 'Inglés p/Negocios', '20', 33, 'Martínez Solano Lucrecia', 32, '3'),
(354, 'Administración General 1', '30', 20, 'Orozco Coto Luis Roberto', 33, '1'),
(355, 'Contabilidad Intermedia', '30', 21, 'Jimenez Sorio Walter', 34, '1'),
(356, 'Estadística Descriptiva', '30', 22, 'Acosta Rivera Pablo', 35, '1'),
(357, 'Legislación Empresarial', '30', 23, 'Collado Parrales Marvin', 36, '1'),
(358, 'Inglés para Negocios II', '20', 19, 'Monge Solano Anabelle', 37, '1'),
(359, 'Inglés para Negocios II', '20', 19, 'Brenes Piedra Geovanny', 37, '5'),
(360, 'Administración General 1', '30', 34, 'Orozco Coto Luis Roberto', 33, '2'),
(361, 'Contabilidad Intermedia', '30', 28, 'Calderón Pizarro Ana', 34, '2'),
(362, 'Estadística Descriptiva', '30', 26, 'Leitón Sancho Nathalie', 35, '2'),
(363, 'Legislación Empresarial ', '30', 25, 'Araya Cespedes Maria del Pilar', 36, '2'),
(364, 'Inglés para Negocios II', '20', 35, 'Leiva Picado Rita', 37, '2'),
(365, 'Administración General 1', '30', 29, 'Pereira Carvajal Adriana', 33, '3'),
(366, 'Contabilidad Intermedia ', '30', 32, 'Calderón Pizarro Ana', 34, '3'),
(367, 'Estadística Descriptiva', '30', 33, 'Leitón Sancho Nathalie', 35, '3'),
(368, 'Legislación Empresarial', '30', 30, 'Alpizar Picado Erick', 36, '3'),
(369, 'Inglés para Negocios II', '20', 31, 'Leiva Picado Rita', 37, '3'),
(370, 'Inglés para Negocios II', '20', 31, 'Campos Arrieta Silvia', 37, '4'),
(371, 'Administración General II', '30', 22, 'CHINCHILLA CERVANTES CARLOS', 38, '1'),
(372, 'Contabilidad Avanzada', '30', 23, 'Quirós Barahona Maureen', 39, '1'),
(373, 'Contabilidad Avanzada', '30', 23, 'Jiménez Sorio Walter', 39, '3'),
(374, 'Estadística Inferencial', '30', 20, 'Brenes Catalán Mauricio', 40, '1'),
(375, 'Matemática Financiera', '30', 21, 'Aguirre Chinchilla Andrés', 41, '1'),
(376, 'Legislación Tributaria ', '30', 19, 'Araya Cespedes Maria del Pilar', 42, '1'),
(377, 'Administración General II', '30', 28, 'Villalta Loaiza Cristina', 38, '2'),
(378, 'Estadística Inferencial', '30', 20, 'Leitón Sancho Nathalie', 40, '4'),
(379, 'Estadìstica Inferencial           ', '30', 26, 'Hernandez Cespedes Marco', 40, '2'),
(380, 'Matemática Financiera                 ', '30', 25, 'Jiménez Sorio Walter', 41, '2'),
(381, 'Legislación Tributaria ', '30', 31, 'Alpizar Picado Erick', 42, '2'),
(382, 'Administración General II', '30', 31, 'Hidalgo Sáenz Róger', 38, '3'),
(383, 'Contabilidad Avanzada', '30', 30, 'Jiménez Sorio Walter', 39, '2'),
(384, 'Estadìstica Inferencial           ', '30', 29, 'Leitón Sancho Nathalie', 40, '3'),
(385, 'Matemática Financiera                 ', '30', 32, 'Hernandez Cespedes Marco', 41, '3'),
(386, 'Legislación Tributaria ', '30', 33, 'Alpizar Picado Erick', 42, '3'),
(387, 'Metodología de la Investigación', '27', 21, 'Cortés Morales Laura', 43, '1'),
(388, 'Contabilidad Costos 1', '30', 19, 'Quirós Barahona Maureen', 44, '1'),
(389, 'Microeconomía', '30', 22, 'SOLANO CORRELLA RODOLFO', 45, '1'),
(390, 'Finanzas 1', '30', 20, 'Meza Cervantes Alberto', 46, '1'),
(391, 'Gerencia de Mercadotecnia I ', '30', 23, 'Castro Marco', 47, '1'),
(392, 'Contabilidad Costos 1', '30', 19, 'Vargas Mora Milton', 44, '3'),
(393, 'Contabilidad Costos 1', '30', 27, 'Aguilar Solano Sergio', 44, '2'),
(394, 'Finanzas 1', '30', 25, 'Campos Segura Mercedes', 46, '2'),
(395, 'Metodología de la Investigación', '30', 32, 'Orozco Coto Luis Roberto', 43, '2'),
(396, 'Microeconomía', '30', 26, 'SOLANO CORRELLA RODOLFO', 45, '3'),
(397, 'Microeconomía', '30', 30, 'SOLANO CORRELLA RODOLFO', 45, '2'),
(398, 'Gerencia de Mercadotecnia I', '30', 31, 'Malavassi Alvarez Sergio', 47, '2'),
(399, 'Legislaciòn Laboral', '30', 19, 'Collado Parrales Marvin', 48, '1'),
(400, 'Contabilidad Costos II', '30', 21, 'Quirós Barahona Maureen', 49, '1'),
(401, 'Macroeconomía                           ', '30', 22, 'Hernández Palma Eugenio', 50, '1'),
(402, 'Finanzas II', '13', 23, 'Hernández Camacho Alexander', 51, '1'),
(403, 'Gerencia de Mercadotecnia II                         ', '14', 20, 'Cortés Morales Laura', 52, '1'),
(404, 'Contabilidad Costos II', '30', 25, 'Vargas Mora Milton', 49, '2'),
(405, 'Macroeconomía                           ', '30', 27, 'Moya Córdoba Adrián', 50, '2'),
(406, 'Gerencia de Mercadotecnia II                         ', '25', 34, 'Espinoza González J.Alfonso', 52, '2'),
(407, 'Legislaciòn Laboral', '30', 32, 'Araya Céspedes Ma. del Pilar', 48, '3'),
(408, 'Finanzas II', '23', 29, 'Campos Segura Mercedes', 51, '2'),
(409, 'Adm. de Rec. Humanos', '30', 22, 'Hidalgo Sáenz Róger', 53, '1'),
(410, 'Auditoría General', '30', 21, 'Monge Chaves Alexander', 54, '1'),
(411, 'Producción y Estrategia               ', '30', 19, 'Brenes Catalán Mauricio', 55, '1'),
(412, 'Producción y Estrategia               ', '30', 35, 'Brenes Morales Orlando', 55, '2'),
(413, 'Administración de Proyectos', '30', 23, 'Alvarez Castro Adriana', 56, '1'),
(414, 'Gerencia y Estrategia                  ', '30', 20, 'Hernández Palma Eugenio', 57, '1'),
(415, 'Práctica Supervisada', '6', 22, 'Espinoza González J.Alfonso', 58, '1'),
(416, 'Práctica Supervisada', '6', 36, 'Espinoza González J.Alfonso', 58, '2'),
(417, 'Práctica Supervisada', '6', 36, 'Espinoza González J.Alfonso', 58, '3'),
(418, 'Práctica Supervisada', '6', 36, 'Moya Córdoba Adrián', 58, '4'),
(419, 'Práctica Supervisada', '6', 36, 'Quiros Brenes Paulo', 58, '5'),
(420, 'Práctica Supervisada', '6', 36, 'Quiros Brenes Paulo', 58, '6'),
(421, 'Práctica Supervisada', '6', 36, 'Hidalgo Montoya Guiselle', 58, '7'),
(422, 'Proyecto de Graduación', '13', 23, 'Villalta Loaiza Cristina', 59, '1'),
(423, 'Adm. de Rec. Humanos', '30', 34, 'Aguilar Solano Sergio', 53, '2'),
(424, 'Auditoría General', '30', 28, 'Aguilar Solano Sergio', 54, '2'),
(425, 'Administración de Proyectos', '30', 25, 'Hidalgo Montoya Guiselle', 56, '2'),
(426, 'Gerencia y Estrategia                  ', '30', 26, 'Espinoza González J.Alfonso', 57, '2'),
(427, 'Comunicación Oral y Escrita', '35', 19, 'Quirós Navarro Dagoberto ', 28, '1'),
(428, 'Contabilidad General ', '35', 20, 'Monge Chaves Alexander', 29, '1'),
(429, 'Matemática p/Administrar Emp.', '30', 21, 'Brenes Catalán Mauricio', 30, '1'),
(430, 'Comp. p/Administrar Emp.', '20', 22, 'Rafael Ramirez Pacheco', 31, '1'),
(431, 'Comp. p/Administrar Emp.', '20', 22, 'Segura Mora Katya', 31, '4'),
(432, 'Inglés p/Negocios', '20', 23, 'Campos Arrieta Silvia', 32, '1'),
(433, 'Inglés p/Negocios', '20', 21, 'Martínez Solano Lucrecia', 32, '4'),
(434, 'Inglés p/Negocios', '20', 21, 'Zúñiga Jiménez Rosa Ileana', 32, '5'),
(435, 'Comunicación Oral y Escrita', '35', 24, 'Garita Lizano Nelly', 28, '2'),
(436, 'Contabilidad General ', '35', 25, 'Segura Abarca Gilbert', 29, '2'),
(437, 'Matemática p/Administrar Emp.', '30', 26, 'Acosta Rivera Pablo', 30, '2'),
(438, 'Comp. p/Administrar Emp.', '20', 27, 'Agüero Montero Rolando', 31, '2'),
(439, 'Inglés p/Negocios', '20', 28, 'Campos Arrieta Silvia', 32, '2'),
(440, 'Comunicación Oral y Escrita', '35', 29, 'Garita Lizano Nelly', 28, '3'),
(441, 'Contabilidad General ', '35', 30, 'Aguirre Chinchilla Andrés', 29, '3'),
(442, 'Contabilidad General ', '35', 20, 'Araya Leandro Alfredo', 29, '4'),
(443, 'Contabilidad General ', '35', 20, 'Quirós Barahona Maureen', 29, '5'),
(444, 'Matemática p/Administrar Emp.', '30', 31, 'Acosta Rivera Pablo', 30, '3'),
(445, 'Matemática p/Administrar Emp.', '30', 21, 'Hernández Cespedes Marco', 30, '4'),
(446, 'Comp. p/Administrar Emp.', '20', 32, 'Abarca Cerdas Damaris', 31, '3'),
(447, 'Comp. p/Administrar Emp.', '20', 31, 'Abarca Cerdas Damaris', 31, '5'),
(448, 'Comp. p/Administrar Emp.', '20', 31, 'Agüero Montero Rolando', 31, '6'),
(449, 'Inglés p/Negocios', '20', 33, 'Martínez Solano Lucrecia', 32, '3'),
(450, 'Administración General 1', '30', 20, 'Orozco Coto Luis Roberto', 33, '1'),
(451, 'Contabilidad Intermedia', '30', 21, 'Jimenez Sorio Walter', 34, '1'),
(452, 'Estadística Descriptiva', '30', 22, 'Acosta Rivera Pablo', 35, '1'),
(453, 'Legislación Empresarial', '30', 23, 'Collado Parrales Marvin', 36, '1'),
(454, 'Inglés para Negocios II', '20', 19, 'Monge Solano Anabelle', 37, '1'),
(455, 'Inglés para Negocios II', '20', 19, 'Brenes Piedra Geovanny', 37, '5'),
(456, 'Administración General 1', '30', 34, 'Orozco Coto Luis Roberto', 33, '2'),
(457, 'Contabilidad Intermedia', '30', 28, 'Calderón Pizarro Ana', 34, '2'),
(458, 'Estadística Descriptiva', '30', 26, 'Leitón Sancho Nathalie', 35, '2'),
(459, 'Legislación Empresarial ', '30', 25, 'Araya Cespedes Maria del Pilar', 36, '2'),
(460, 'Inglés para Negocios II', '20', 35, 'Leiva Picado Rita', 37, '2'),
(461, 'Administración General 1', '30', 29, 'Pereira Carvajal Adriana', 33, '3'),
(462, 'Contabilidad Intermedia ', '30', 32, 'Calderón Pizarro Ana', 34, '3'),
(463, 'Estadística Descriptiva', '30', 33, 'Leitón Sancho Nathalie', 35, '3'),
(464, 'Legislación Empresarial', '30', 30, 'Alpizar Picado Erick', 36, '3'),
(465, 'Inglés para Negocios II', '20', 31, 'Leiva Picado Rita', 37, '3'),
(466, 'Inglés para Negocios II', '20', 31, 'Campos Arrieta Silvia', 37, '4'),
(467, 'Administración General II', '30', 22, 'CHINCHILLA CERVANTES CARLOS', 38, '1'),
(468, 'Contabilidad Avanzada', '30', 23, 'Quirós Barahona Maureen', 39, '1'),
(469, 'Contabilidad Avanzada', '30', 23, 'Jiménez Sorio Walter', 39, '3'),
(470, 'Estadística Inferencial', '30', 20, 'Brenes Catalán Mauricio', 40, '1'),
(471, 'Matemática Financiera', '30', 21, 'Aguirre Chinchilla Andrés', 41, '1'),
(472, 'Legislación Tributaria ', '30', 19, 'Araya Cespedes Maria del Pilar', 42, '1'),
(473, 'Administración General II', '30', 28, 'Villalta Loaiza Cristina', 38, '2'),
(474, 'Estadística Inferencial', '30', 20, 'Leitón Sancho Nathalie', 40, '4'),
(475, 'Estadìstica Inferencial           ', '30', 26, 'Hernandez Cespedes Marco', 40, '2'),
(476, 'Matemática Financiera                 ', '30', 25, 'Jiménez Sorio Walter', 41, '2'),
(477, 'Legislación Tributaria ', '30', 31, 'Alpizar Picado Erick', 42, '2'),
(478, 'Administración General II', '30', 31, 'Hidalgo Sáenz Róger', 38, '3'),
(479, 'Contabilidad Avanzada', '30', 30, 'Jiménez Sorio Walter', 39, '2'),
(480, 'Estadìstica Inferencial           ', '30', 29, 'Leitón Sancho Nathalie', 40, '3'),
(481, 'Matemática Financiera                 ', '30', 32, 'Hernandez Cespedes Marco', 41, '3'),
(482, 'Legislación Tributaria ', '30', 33, 'Alpizar Picado Erick', 42, '3'),
(483, 'Metodología de la Investigación', '27', 21, 'Cortés Morales Laura', 43, '1'),
(484, 'Contabilidad Costos 1', '30', 19, 'Quirós Barahona Maureen', 44, '1'),
(485, 'Microeconomía', '30', 22, 'SOLANO CORRELLA RODOLFO', 45, '1'),
(486, 'Finanzas 1', '30', 20, 'Meza Cervantes Alberto', 46, '1'),
(487, 'Gerencia de Mercadotecnia I ', '30', 23, 'Castro Marco', 47, '1'),
(488, 'Contabilidad Costos 1', '30', 19, 'Vargas Mora Milton', 44, '3'),
(489, 'Contabilidad Costos 1', '30', 27, 'Aguilar Solano Sergio', 44, '2'),
(490, 'Finanzas 1', '30', 25, 'Campos Segura Mercedes', 46, '2'),
(491, 'Metodología de la Investigación', '30', 32, 'Orozco Coto Luis Roberto', 43, '2'),
(492, 'Microeconomía', '30', 26, 'SOLANO CORRELLA RODOLFO', 45, '3'),
(493, 'Microeconomía', '30', 30, 'SOLANO CORRELLA RODOLFO', 45, '2'),
(494, 'Gerencia de Mercadotecnia I', '30', 31, 'Malavassi Alvarez Sergio', 47, '2'),
(495, 'Legislaciòn Laboral', '30', 19, 'Collado Parrales Marvin', 48, '1'),
(496, 'Contabilidad Costos II', '30', 21, 'Quirós Barahona Maureen', 49, '1'),
(497, 'Macroeconomía                           ', '30', 22, 'Hernández Palma Eugenio', 50, '1'),
(498, 'Finanzas II', '13', 23, 'Hernández Camacho Alexander', 51, '1'),
(499, 'Gerencia de Mercadotecnia II                         ', '14', 20, 'Cortés Morales Laura', 52, '1'),
(500, 'Contabilidad Costos II', '30', 25, 'Vargas Mora Milton', 49, '2'),
(501, 'Macroeconomía                           ', '30', 27, 'Moya Córdoba Adrián', 50, '2'),
(502, 'Gerencia de Mercadotecnia II                         ', '25', 34, 'Espinoza González J.Alfonso', 52, '2'),
(503, 'Legislaciòn Laboral', '30', 32, 'Araya Céspedes Ma. del Pilar', 48, '3'),
(504, 'Finanzas II', '23', 29, 'Campos Segura Mercedes', 51, '2'),
(505, 'Adm. de Rec. Humanos', '30', 22, 'Hidalgo Sáenz Róger', 53, '1'),
(506, 'Auditoría General', '30', 21, 'Monge Chaves Alexander', 54, '1'),
(507, 'Producción y Estrategia               ', '30', 19, 'Brenes Catalán Mauricio', 55, '1'),
(508, 'Producción y Estrategia               ', '30', 35, 'Brenes Morales Orlando', 55, '2'),
(509, 'Administración de Proyectos', '30', 23, 'Alvarez Castro Adriana', 56, '1'),
(510, 'Gerencia y Estrategia                  ', '30', 20, 'Hernández Palma Eugenio', 57, '1'),
(511, 'Práctica Supervisada', '6', 22, 'Espinoza González J.Alfonso', 58, '1'),
(512, 'Práctica Supervisada', '6', 36, 'Espinoza González J.Alfonso', 58, '2'),
(513, 'Práctica Supervisada', '6', 36, 'Espinoza González J.Alfonso', 58, '3'),
(514, 'Práctica Supervisada', '6', 36, 'Moya Córdoba Adrián', 58, '4'),
(515, 'Práctica Supervisada', '6', 36, 'Quiros Brenes Paulo', 58, '5'),
(516, 'Práctica Supervisada', '6', 36, 'Quiros Brenes Paulo', 58, '6'),
(517, 'Práctica Supervisada', '6', 36, 'Hidalgo Montoya Guiselle', 58, '7'),
(518, 'Proyecto de Graduación', '13', 23, 'Villalta Loaiza Cristina', 59, '1'),
(519, 'Adm. de Rec. Humanos', '30', 34, 'Aguilar Solano Sergio', 53, '2'),
(520, 'Auditoría General', '30', 28, 'Aguilar Solano Sergio', 54, '2'),
(521, 'Administración de Proyectos', '30', 25, 'Hidalgo Montoya Guiselle', 56, '2'),
(522, 'Gerencia y Estrategia                  ', '30', 26, 'Espinoza González J.Alfonso', 57, '2'),
(523, 'Ingles', '25', 21, 'Zúñiga Jiménez Rosa Ileana', 1, '4');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupo_x_aula`
--

CREATE TABLE `grupo_x_aula` (
  `cod_aula` int(11) DEFAULT NULL,
  `cod_grupo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `grupo_x_aula`
--

INSERT INTO `grupo_x_aula` (`cod_aula`, `cod_grupo`) VALUES
(NULL, 229),
(12, 231),
(13, 232),
(14, 233),
(15, 234),
(16, 235),
(17, 236),
(18, 237),
(19, 238),
(20, 239),
(21, 240),
(22, 241),
(23, 242),
(24, 243),
(25, 244),
(26, 245),
(27, 246),
(28, 247),
(29, 248),
(30, 249),
(31, 250),
(32, 251),
(33, 252),
(34, 253),
(35, 254),
(36, 255),
(NULL, 257),
(39, 258),
(40, 259),
(41, 260),
(42, 261),
(43, 262),
(44, 263),
(45, 264),
(46, 265),
(47, 266),
(48, 267),
(NULL, 268),
(50, 269),
(51, 270),
(52, 271),
(53, 272),
(54, 273),
(NULL, 274),
(56, 275),
(57, 276),
(58, 277),
(59, 278),
(60, 279),
(61, 280),
(62, 281),
(63, 282),
(64, 283),
(65, 284),
(66, 285),
(68, 287),
(69, 288),
(70, 289),
(71, 290),
(72, 291),
(73, 292),
(74, 293),
(75, 294),
(76, 295),
(77, 296),
(78, 297),
(79, 298),
(80, 299),
(81, 300),
(82, 301),
(83, 302),
(84, 303),
(85, 304),
(86, 305),
(87, 306),
(88, 307),
(89, 308),
(90, 309),
(91, 310),
(92, 311),
(93, 312),
(94, 313),
(95, 314),
(96, 315),
(97, 316),
(98, 317),
(99, 318),
(100, 319),
(101, 320),
(102, 321),
(103, 322),
(104, 323),
(105, 324),
(NULL, 327),
(NULL, 328),
(NULL, 329),
(NULL, 330),
(NULL, 229),
(NULL, 257),
(NULL, 257),
(NULL, 327),
(NULL, 329),
(NULL, 329),
(NULL, 329),
(NULL, 329),
(NULL, 329),
(NULL, 329),
(NULL, 329),
(NULL, 229),
(NULL, 229),
(NULL, 229),
(NULL, 229),
(58, 277),
(106, 331),
(107, 332),
(108, 333),
(109, 334),
(110, 335),
(111, 336),
(112, 337),
(113, 338),
(114, 339),
(115, 340),
(116, 341),
(117, 342),
(118, 343),
(119, 344),
(120, 345),
(121, 346),
(122, 347),
(123, 348),
(124, 349),
(125, 350),
(126, 351),
(127, 352),
(128, 353),
(129, 354),
(130, 355),
(131, 356),
(132, 357),
(133, 358),
(134, 359),
(135, 360),
(136, 361),
(137, 362),
(138, 363),
(139, 364),
(140, 365),
(141, 366),
(142, 367),
(143, 368),
(144, 369),
(145, 370),
(146, 371),
(147, 372),
(148, 373),
(149, 374),
(150, 375),
(151, 376),
(152, 377),
(153, 378),
(154, 379),
(155, 380),
(156, 381),
(157, 382),
(158, 383),
(159, 384),
(160, 385),
(161, 386),
(162, 387),
(164, 389),
(165, 390),
(166, 391),
(168, 393),
(169, 394),
(170, 395),
(171, 396),
(172, 397),
(173, 398),
(174, 399),
(175, 400),
(176, 401),
(177, 402),
(178, 403),
(179, 404),
(180, 405),
(181, 406),
(182, 407),
(183, 408),
(184, 409),
(185, 410),
(186, 411),
(187, 412),
(188, 413),
(189, 414),
(190, 415),
(191, 416),
(192, 417),
(193, 418),
(194, 419),
(195, 420),
(196, 421),
(197, 422),
(198, 423),
(199, 424),
(200, 425),
(201, 426),
(38, 229),
(202, 427),
(203, 428),
(204, 429),
(205, 430),
(206, 431),
(207, 432),
(208, 433),
(209, 434),
(210, 435),
(211, 436),
(212, 437),
(213, 438),
(214, 439),
(215, 440),
(216, 441),
(217, 442),
(218, 443),
(219, 444),
(220, 445),
(221, 446),
(222, 447),
(223, 448),
(224, 449),
(225, 450),
(226, 451),
(227, 452),
(228, 453),
(229, 454),
(230, 455),
(231, 456),
(232, 457),
(233, 458),
(234, 459),
(235, 460),
(236, 461),
(237, 462),
(238, 463),
(239, 464),
(240, 465),
(241, 466),
(242, 467),
(243, 468),
(244, 469),
(245, 470),
(246, 471),
(247, 472),
(248, 473),
(249, 474),
(250, 475),
(251, 476),
(252, 477),
(253, 478),
(254, 479),
(255, 480),
(256, 481),
(257, 482),
(258, 483),
(259, 484),
(260, 485),
(261, 486),
(262, 487),
(263, 488),
(264, 489),
(265, 490),
(266, 491),
(267, 492),
(268, 493),
(269, 494),
(270, 495),
(271, 496),
(272, 497),
(273, 498),
(274, 499),
(275, 500),
(276, 501),
(277, 502),
(278, 503),
(279, 504),
(280, 505),
(281, 506),
(282, 507),
(283, 508),
(284, 509),
(285, 510),
(286, 511),
(287, 512),
(288, 513),
(289, 514),
(290, 515),
(291, 516),
(292, 517),
(293, 518),
(294, 519),
(295, 520),
(296, 521),
(297, 522),
(22, 523);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `grupo_x_estudiante`
--

CREATE TABLE `grupo_x_estudiante` (
  `cod_grupo_x_estudiante` int(100) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `cod_grupo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horario`
--

CREATE TABLE `horario` (
  `cod_horario` int(100) NOT NULL,
  `dia` char(2) NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `cod_oferta` int(11) NOT NULL,
  `cod_periodo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `horario`
--

INSERT INTO `horario` (`cod_horario`, `dia`, `hora_inicio`, `hora_fin`, `cod_oferta`, `cod_periodo`) VALUES
(19, 'M', '19:00:00', '22:40:00', 5, 9),
(20, 'K', '19:00:00', '22:40:00', 5, 9),
(21, 'L', '19:00:00', '22:40:00', 5, 9),
(22, 'V', '19:00:00', '22:40:00', 5, 9),
(23, 'J', '19:00:00', '22:40:00', 5, 9),
(24, 'M', '14:00:00', '17:40:00', 5, 9),
(25, 'L', '15:00:00', '18:40:00', 5, 9),
(26, 'K', '15:00:00', '18:40:00', 5, 9),
(27, 'V', '15:00:00', '18:40:00', 5, 9),
(28, 'J', '15:00:00', '18:40:00', 5, 9),
(29, 'J', '09:00:00', '12:40:00', 5, 9),
(30, 'K', '09:00:00', '12:40:00', 5, 9),
(31, 'L', '09:00:00', '12:40:00', 5, 9),
(32, 'M', '09:00:00', '12:40:00', 5, 9),
(33, 'V', '09:00:00', '12:40:00', 5, 9),
(34, 'M', '15:00:00', '18:40:00', 5, 9),
(35, 'V', '14:00:00', '17:40:00', 5, 9),
(36, 'S', '09:00:00', '12:40:00', 5, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `matricula_estudiante`
--

CREATE TABLE `matricula_estudiante` (
  `cod_matricula` int(11) NOT NULL,
  `cod_grupo` int(100) NOT NULL,
  `id_estudiante` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `matricula_estudiante`
--

INSERT INTO `matricula_estudiante` (`cod_matricula`, `cod_grupo`, `id_estudiante`) VALUES
(1, 242, 302220222),
(2, 281, 302220222),
(3, 268, 302220222);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ofertaacademica`
--

CREATE TABLE `ofertaacademica` (
  `cod_oferta` int(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `archivo` varchar(100) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `ofertaacademica`
--

INSERT INTO `ofertaacademica` (`cod_oferta`, `nombre`, `archivo`, `fecha_inicio`, `fecha_fin`) VALUES
(1, 'Oferta Tecnologías de la Información', 'ofertaTI.xlsx', '2020-09-14', '2020-12-14'),
(2, 'Oferta2', 'oferta2.xlsx', '2020-09-14', '2020-12-14'),
(3, 'Oferta3', 'oferta3.xlsx', '2020-09-14', '2020-12-14'),
(5, 'Datos.xlsx', '../archivos/Datos.xlsx', '2020-08-21', '2020-12-19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodos`
--

CREATE TABLE `periodos` (
  `cod_periodo` int(100) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_final` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `periodos`
--

INSERT INTO `periodos` (`cod_periodo`, `fecha_inicio`, `fecha_final`) VALUES
(4, '2020-08-20', '2020-12-18'),
(9, '2020-08-21', '2020-12-19');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `id_permiso` int(100) NOT NULL,
  `descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personas`
--

CREATE TABLE `personas` (
  `id_persona` int(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `correo` varchar(100) DEFAULT NULL,
  `foto` varchar(100) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `contrasena` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `personas`
--

INSERT INTO `personas` (`id_persona`, `nombre`, `apellidos`, `correo`, `foto`, `id_rol`, `contrasena`) VALUES
(118210940, 'Alberto', 'Solano Villalta', NULL, 'alberto.jpg', 2, 'hola1234'),
(301110111, 'Garita Lizano Nelly', 'Vega Monge', NULL, 'julian.jpg', 1, 'julian123'),
(302220222, 'Maria', 'Perez Lopez', NULL, 'maria.jpg', 2, 'maria123'),
(303330333, 'Pablo', 'Arce Martinez', 'parcem.apsw3@gmail.com', 'pablo.jpg', 3, 'pablo123'),
(304440444, 'Lucia', 'Brenes Viquez', 'lbrenesv.apsw3@yahoo.com', 'lucia.jpg', 4, 'lucia123'),
(305550555, 'Sergio', 'Miranda Montes', 'smirandam.apsw3@yahoo.com', 'sergio.jpg', 5, 'sergio123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesor_x_curso`
--

CREATE TABLE `profesor_x_curso` (
  `cod_profesor_curso` int(100) NOT NULL,
  `id_profesor` int(11) NOT NULL,
  `id_curso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Prueba`
--

CREATE TABLE `Prueba` (
  `ID` int(11) NOT NULL,
  `Titulo` int(11) NOT NULL,
  `Encargado` int(11) NOT NULL,
  `Descirpcion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Volcado de datos para la tabla `Prueba`
--

INSERT INTO `Prueba` (`ID`, `Titulo`, `Encargado`, `Descirpcion`) VALUES
(1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id_rol` int(100) NOT NULL,
  `descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `descripcion`) VALUES
(1, 'Profesor'),
(2, 'Estudiante'),
(3, 'EncargadoOferta'),
(4, 'Distribuidor'),
(5, 'Director');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol_permiso`
--

CREATE TABLE `rol_permiso` (
  `id_rol_permiso` int(100) NOT NULL,
  `id_permiso` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes`
--

CREATE TABLE `solicitudes` (
  `cod_solicitud` int(11) NOT NULL,
  `grupo` int(11) NOT NULL,
  `aula` int(11) NOT NULL,
  `user_envio` int(11) NOT NULL,
  `user_recibo` int(11) NOT NULL,
  `estado` int(1) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `asunto` varchar(200) NOT NULL,
  `mensaje` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `solicitudes`
--

INSERT INTO `solicitudes` (`cod_solicitud`, `grupo`, `aula`, `user_envio`, `user_recibo`, `estado`, `titulo`, `asunto`, `mensaje`) VALUES
(11, 327, 3, 304440444, 305550555, 2, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 327 al Aula 3 .Gracias.'),
(12, 327, 5, 304440444, 305550555, 2, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 327 al Aula 5 .Gracias.'),
(13, 257, 5, 304440444, 305550555, 2, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 257 al Aula 5 .Gracias.'),
(14, 229, 5, 304440444, 305550555, 2, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 229 al Aula 5 .Gracias.'),
(15, 229, 9, 304440444, 305550555, 2, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 229 al Aula 9 .Gracias.'),
(16, 229, 3, 304440444, 305550555, 1, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 229 al Aula 3 .Gracias.'),
(17, 274, 4, 304440444, 305550555, 1, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 274 al Aula 4 .Gracias.'),
(18, 229, 5, 304440444, 305550555, 2, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 229 al Aula 5 .Gracias.'),
(19, 523, 22, 304440444, 305550555, 1, 'Solicitud de cambio', 'Cambio de grupo', 'Buenas, este mensaje es para solicitar el cambio de el Grupo 523 al Aula 22 .Gracias.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `temp_grupos`
--

CREATE TABLE `temp_grupos` (
  `cod_grupo` int(100) NOT NULL,
  `descripcion` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `tamaño` varchar(11) COLLATE utf8_unicode_ci NOT NULL,
  `cod_horario` int(11) DEFAULT NULL,
  `nombre_profesor` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `id_curso` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_de_aula`
--

CREATE TABLE `tipo_de_aula` (
  `cod_tipo` int(100) NOT NULL,
  `descripcion2` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `tipo_de_aula`
--

INSERT INTO `tipo_de_aula` (`cod_tipo`, `descripcion2`) VALUES
(1, 'Aula'),
(2, 'Laboratorio'),
(3, 'Administrativa'),
(4, 'Publica');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(100) NOT NULL,
  `contraseña` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `contraseña`) VALUES
(118210940, 0x4236383641433938333342334141343338343344343337384642393145433133);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aulas`
--
ALTER TABLE `aulas`
  ADD PRIMARY KEY (`cod_aula`),
  ADD KEY `cod_edificio` (`cod_edificio`),
  ADD KEY `cod_tipo` (`cod_tipo`);

--
-- Indices de la tabla `aulas_x_disponibilidad`
--
ALTER TABLE `aulas_x_disponibilidad`
  ADD PRIMARY KEY (`id_disponibilidad`),
  ADD KEY `cod_aula` (`cod_aula`),
  ADD KEY `cod_horario` (`cod_horario`);

--
-- Indices de la tabla `carreras`
--
ALTER TABLE `carreras`
  ADD PRIMARY KEY (`id_carrera`),
  ADD KEY `id_director_carrera` (`id_director_carrera`);

--
-- Indices de la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD PRIMARY KEY (`id_curso`),
  ADD KEY `id_carrera` (`id_carrera`);

--
-- Indices de la tabla `edificios`
--
ALTER TABLE `edificios`
  ADD PRIMARY KEY (`cod_edificio`);

--
-- Indices de la tabla `grupos2`
--
ALTER TABLE `grupos2`
  ADD PRIMARY KEY (`cod_grupo`),
  ADD KEY `cod_horario` (`cod_horario`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `grupo_x_aula`
--
ALTER TABLE `grupo_x_aula`
  ADD KEY `cod_grupo` (`cod_grupo`),
  ADD KEY `cod_aula` (`cod_aula`) USING BTREE;

--
-- Indices de la tabla `grupo_x_estudiante`
--
ALTER TABLE `grupo_x_estudiante`
  ADD PRIMARY KEY (`cod_grupo_x_estudiante`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `cod_grupo` (`cod_grupo`);

--
-- Indices de la tabla `horario`
--
ALTER TABLE `horario`
  ADD PRIMARY KEY (`cod_horario`),
  ADD KEY `cod_oferta` (`cod_oferta`),
  ADD KEY `cod_periodo` (`cod_periodo`);

--
-- Indices de la tabla `matricula_estudiante`
--
ALTER TABLE `matricula_estudiante`
  ADD PRIMARY KEY (`cod_matricula`),
  ADD KEY `id_estudiante` (`id_estudiante`),
  ADD KEY `cod_grupo` (`cod_grupo`);

--
-- Indices de la tabla `ofertaacademica`
--
ALTER TABLE `ofertaacademica`
  ADD PRIMARY KEY (`cod_oferta`);

--
-- Indices de la tabla `periodos`
--
ALTER TABLE `periodos`
  ADD PRIMARY KEY (`cod_periodo`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`id_permiso`);

--
-- Indices de la tabla `personas`
--
ALTER TABLE `personas`
  ADD PRIMARY KEY (`id_persona`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `profesor_x_curso`
--
ALTER TABLE `profesor_x_curso`
  ADD PRIMARY KEY (`cod_profesor_curso`),
  ADD KEY `id_profesor` (`id_profesor`),
  ADD KEY `id_curso` (`id_curso`);

--
-- Indices de la tabla `Prueba`
--
ALTER TABLE `Prueba`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD PRIMARY KEY (`id_rol_permiso`),
  ADD KEY `id_permiso` (`id_permiso`),
  ADD KEY `id_rol` (`id_rol`);

--
-- Indices de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD PRIMARY KEY (`cod_solicitud`),
  ADD KEY `grupo` (`grupo`),
  ADD KEY `aula` (`aula`),
  ADD KEY `user_envio` (`user_envio`),
  ADD KEY `user_recibo` (`user_recibo`);

--
-- Indices de la tabla `temp_grupos`
--
ALTER TABLE `temp_grupos`
  ADD PRIMARY KEY (`cod_grupo`);

--
-- Indices de la tabla `tipo_de_aula`
--
ALTER TABLE `tipo_de_aula`
  ADD PRIMARY KEY (`cod_tipo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD KEY `id_usuario` (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aulas`
--
ALTER TABLE `aulas`
  MODIFY `cod_aula` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT de la tabla `aulas_x_disponibilidad`
--
ALTER TABLE `aulas_x_disponibilidad`
  MODIFY `id_disponibilidad` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=298;

--
-- AUTO_INCREMENT de la tabla `carreras`
--
ALTER TABLE `carreras`
  MODIFY `id_carrera` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `cursos`
--
ALTER TABLE `cursos`
  MODIFY `id_curso` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT de la tabla `edificios`
--
ALTER TABLE `edificios`
  MODIFY `cod_edificio` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT de la tabla `grupos2`
--
ALTER TABLE `grupos2`
  MODIFY `cod_grupo` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=524;

--
-- AUTO_INCREMENT de la tabla `grupo_x_estudiante`
--
ALTER TABLE `grupo_x_estudiante`
  MODIFY `cod_grupo_x_estudiante` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horario`
--
ALTER TABLE `horario`
  MODIFY `cod_horario` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `matricula_estudiante`
--
ALTER TABLE `matricula_estudiante`
  MODIFY `cod_matricula` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ofertaacademica`
--
ALTER TABLE `ofertaacademica`
  MODIFY `cod_oferta` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `periodos`
--
ALTER TABLE `periodos`
  MODIFY `cod_periodo` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `id_permiso` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `profesor_x_curso`
--
ALTER TABLE `profesor_x_curso`
  MODIFY `cod_profesor_curso` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Prueba`
--
ALTER TABLE `Prueba`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_rol` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  MODIFY `id_rol_permiso` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  MODIFY `cod_solicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `temp_grupos`
--
ALTER TABLE `temp_grupos`
  MODIFY `cod_grupo` int(100) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_de_aula`
--
ALTER TABLE `tipo_de_aula`
  MODIFY `cod_tipo` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `aulas`
--
ALTER TABLE `aulas`
  ADD CONSTRAINT `aulas_ibfk_1` FOREIGN KEY (`cod_edificio`) REFERENCES `edificios` (`cod_edificio`),
  ADD CONSTRAINT `aulas_ibfk_2` FOREIGN KEY (`cod_tipo`) REFERENCES `tipo_de_aula` (`cod_tipo`);

--
-- Filtros para la tabla `aulas_x_disponibilidad`
--
ALTER TABLE `aulas_x_disponibilidad`
  ADD CONSTRAINT `aulas_x_disponibilidad_ibfk_1` FOREIGN KEY (`cod_aula`) REFERENCES `aulas` (`cod_aula`),
  ADD CONSTRAINT `aulas_x_disponibilidad_ibfk_2` FOREIGN KEY (`cod_horario`) REFERENCES `horario` (`cod_horario`);

--
-- Filtros para la tabla `carreras`
--
ALTER TABLE `carreras`
  ADD CONSTRAINT `carreras_ibfk_1` FOREIGN KEY (`id_director_carrera`) REFERENCES `personas` (`id_persona`);

--
-- Filtros para la tabla `cursos`
--
ALTER TABLE `cursos`
  ADD CONSTRAINT `cursos_ibfk_1` FOREIGN KEY (`id_carrera`) REFERENCES `carreras` (`id_carrera`);

--
-- Filtros para la tabla `grupos2`
--
ALTER TABLE `grupos2`
  ADD CONSTRAINT `grupos2_ibfk_1` FOREIGN KEY (`cod_horario`) REFERENCES `horario` (`cod_horario`),
  ADD CONSTRAINT `grupos2_ibfk_2` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`);

--
-- Filtros para la tabla `grupo_x_aula`
--
ALTER TABLE `grupo_x_aula`
  ADD CONSTRAINT `grupo_x_aula_ibfk_1` FOREIGN KEY (`cod_grupo`) REFERENCES `grupos2` (`cod_grupo`),
  ADD CONSTRAINT `grupo_x_aula_ibfk_3` FOREIGN KEY (`cod_aula`) REFERENCES `aulas_x_disponibilidad` (`id_disponibilidad`);

--
-- Filtros para la tabla `grupo_x_estudiante`
--
ALTER TABLE `grupo_x_estudiante`
  ADD CONSTRAINT `grupo_x_estudiante_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `grupo_x_estudiante_ibfk_2` FOREIGN KEY (`cod_grupo`) REFERENCES `grupos` (`cod_grupo`);

--
-- Filtros para la tabla `horario`
--
ALTER TABLE `horario`
  ADD CONSTRAINT `horario_ibfk_1` FOREIGN KEY (`cod_oferta`) REFERENCES `ofertaacademica` (`cod_oferta`),
  ADD CONSTRAINT `horario_ibfk_2` FOREIGN KEY (`cod_oferta`) REFERENCES `ofertaacademica` (`cod_oferta`),
  ADD CONSTRAINT `horario_ibfk_3` FOREIGN KEY (`cod_periodo`) REFERENCES `periodos` (`cod_periodo`);

--
-- Filtros para la tabla `matricula_estudiante`
--
ALTER TABLE `matricula_estudiante`
  ADD CONSTRAINT `matricula_estudiante_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `matricula_estudiante_ibfk_2` FOREIGN KEY (`cod_grupo`) REFERENCES `grupos2` (`cod_grupo`);

--
-- Filtros para la tabla `personas`
--
ALTER TABLE `personas`
  ADD CONSTRAINT `personas_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);

--
-- Filtros para la tabla `profesor_x_curso`
--
ALTER TABLE `profesor_x_curso`
  ADD CONSTRAINT `profesor_x_curso_ibfk_1` FOREIGN KEY (`id_profesor`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `profesor_x_curso_ibfk_2` FOREIGN KEY (`id_profesor`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `profesor_x_curso_ibfk_3` FOREIGN KEY (`id_profesor`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `profesor_x_curso_ibfk_4` FOREIGN KEY (`id_curso`) REFERENCES `cursos` (`id_curso`);

--
-- Filtros para la tabla `rol_permiso`
--
ALTER TABLE `rol_permiso`
  ADD CONSTRAINT `rol_permiso_ibfk_1` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`),
  ADD CONSTRAINT `rol_permiso_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);

--
-- Filtros para la tabla `solicitudes`
--
ALTER TABLE `solicitudes`
  ADD CONSTRAINT `solicitudes_ibfk_1` FOREIGN KEY (`grupo`) REFERENCES `grupos2` (`cod_grupo`),
  ADD CONSTRAINT `solicitudes_ibfk_2` FOREIGN KEY (`aula`) REFERENCES `aulas` (`cod_aula`),
  ADD CONSTRAINT `solicitudes_ibfk_3` FOREIGN KEY (`user_envio`) REFERENCES `personas` (`id_persona`),
  ADD CONSTRAINT `solicitudes_ibfk_4` FOREIGN KEY (`user_recibo`) REFERENCES `personas` (`id_persona`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `personas` (`id_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
