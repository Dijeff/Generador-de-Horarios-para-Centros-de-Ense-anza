<?php
include_once 'conexion.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';

               
$descripcion = (isset($_POST['descripcion'])) ? $_POST['descripcion'] : $_POST['descripcion'];
$tamano = (isset($_POST['tamano'])) ? $_POST['tamano'] : '';
$cod_horario = (isset($_POST['cod_horario'])) ? $_POST['cod_horario'] : '';
$nombre_profesor = (isset($_POST['nombre_profesor'])) ? $_POST['nombre_profesor'] : '';
$id_curso = (isset($_POST['id_curso'])) ? $_POST['id_curso'] : '';
$id_grupo = (isset($_POST['id_grupo'])) ? $_POST['id_grupo'] : '';

$dia  =$cod_horario[0];

switch ($opcion) {
    case 1:

        $pQuery = $conexion->prepare(" call ingresar_grupo_manual(:descripcion,:capacidad,:ubicacion,:estado,:cod_edificio,:id_grupo); ");
        $pQuery->bindParam(':descripcion', $descripcion);
        $pQuery->bindParam(':capacidad', $tamano);
        $pQuery->bindParam(':ubicacion', $dia);
        $pQuery->bindParam(':estado', $nombre_profesor);
        $pQuery->bindParam(':cod_edificio', $id_curso);
         $pQuery->bindParam(':id_grupo', $id_grupo);
        $pQuery->execute();
        break;
   
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
