<?php
    class Conexion{
        public static function Conectar(){
            define('servidor','localhost');
            define('nombre_bd','id15465931_apswbd');
            define('usuario','id15465931_sa');
            define('password','$NV9<X$uerA8B>1J');
            $opciones = array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8');
            try{
             
              $conexion = new PDO("mysql:host=".servidor."; dbname=".nombre_bd, usuario, password, $opciones); 
                //echo "Conexion Exitosa <br>";
                return $conexion;
            }catch(Exception $e){
                die("El error de Conexion es: ".$e->getMessage());
            }  
        }
    }
?>