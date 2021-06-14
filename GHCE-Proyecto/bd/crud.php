<?php
include_once 'conexion.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';



$nombre = (isset($_POST['nombre'])) ? $_POST['nombre'] : '';
$ubicacion = (isset($_POST['ubicacion'])) ? $_POST['ubicacion'] : '';
$cantidad = (isset($_POST['cantidad'])) ? $_POST['cantidad'] : '';
$pisos = (isset($_POST['pisos'])) ? $_POST['pisos'] : '';
$estado = (isset($_POST['estado'])) ? $_POST['estado'] : $_POST['estado'];
$foto = (isset($_POST['foto'])) ? $_POST['foto'] : $_POST['foto'];

$foto  =substr($foto,12);
switch ($opcion) {
    case 1:
       
        $pQuery = $conexion->prepare(" call sp_insertar_edificio(:descripcion,:ubicacion,:num_aulas,:pisos,:estado,:foto); ");
        $pQuery->bindParam(':descripcion', $nombre);
        $pQuery->bindParam(':ubicacion', $ubicacion);
        $pQuery->bindParam(':num_aulas', $cantidad);
        $pQuery->bindParam(':pisos', $pisos);
        $pQuery->bindParam(':estado', $estado);
        $pQuery->bindParam(':foto', $foto);
        $pQuery->execute();
        break;
        
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
