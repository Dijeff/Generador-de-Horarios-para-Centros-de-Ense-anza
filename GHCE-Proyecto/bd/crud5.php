<?php
include_once 'conexion.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';
$id = (isset($_POST['id'])) ? $_POST['id'] : '';
$id2 = (isset($_POST['id2'])) ? $_POST['id2'] : '';


switch ($opcion) {
    
    case 1:
       
          $pQuery = $conexion->prepare(" call eliminar_grupo_aula(:descripcion,:descripcion2); ");
        $pQuery->bindParam(':descripcion', $id);
         $pQuery->bindParam(':descripcion2', $id2);
        $pQuery->execute();
        break;
   
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
?>
