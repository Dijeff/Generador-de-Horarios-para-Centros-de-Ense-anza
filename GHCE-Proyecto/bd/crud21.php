<?php
include_once 'conexion.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';

$id = (isset($_POST['id'])) ? $_POST['id'] : $_POST['id'];
$nombreaula = (isset($_POST['nombreaula'])) ? $_POST['nombreaula'] : '';
$capacidad = (isset($_POST['capacidad'])) ? $_POST['capacidad'] : '';
$edificio = (isset($_POST['edificio'])) ? $_POST['edificio'] : '';
$tipo = (isset($_POST['tipo'])) ? $_POST['tipo'] : '';
$ubicacion = (isset($_POST['ubicacion'])) ? $_POST['ubicacion'] : $_POST['ubicacion'];
$estado = (isset($_POST['estado'])) ? $_POST['estado'] : $_POST['estado'];

switch ($opcion) {
    case 1:

        $pQuery = $conexion->prepare("call sp_insertar_aula(:descripcion,:capacidad,:ubicacion,:estado,:cod_edificio,:tipo);");
        $pQuery->bindParam(':descripcion', $nombreaula);
        $pQuery->bindParam(':capacidad', $capacidad);
        $pQuery->bindParam(':ubicacion', $ubicacion);
        $pQuery->bindParam(':estado', $estado);
        $pQuery->bindParam(':cod_edificio', $edificio);
        $pQuery->bindParam(':tipo', $tipo);
        $pQuery->execute();
        break;
    case 2:

        $resultado = $conexion->prepare("call listar_aulas(:cod)");
        $resultado->bindParam(':cod', $edificio);
        $resultado->execute();
        $data = array();
        while ($r = $resultado->fetchAll(PDO::FETCH_ASSOC)) {
            $data[] = $r;
        }
        echo json_encode(array("contactos2" => $data));

        break;
    case 3:
        $pQuery = $conexion->prepare(" call sp_editar_aula(:id,:descripcion,:capacidad,:ubicacion,:estado,:cod_edificio,:tipo); ");
        $pQuery->bindParam(':id', $id);
        $pQuery->bindParam(':descripcion', $nombreaula);
        $pQuery->bindParam(':capacidad', $capacidad);
        $pQuery->bindParam(':ubicacion', $ubicacion);
        $pQuery->bindParam(':estado', $estado);
        $pQuery->bindParam(':cod_edificio', $edificio);
        $pQuery->bindParam(':tipo', $tipo);
        $pQuery->execute();
        $data = $resultado->fetchAll(PDO::FETCH_ASSOC);
        break;
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
