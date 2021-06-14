<?php
include_once 'conexion.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';

               
$grupo = (isset($_POST['grupo'])) ? $_POST['grupo'] : $_POST['grupo'];
$aula = (isset($_POST['aula'])) ? $_POST['aula'] : '';
$userenvio = (isset($_POST['userenvio'])) ? $_POST['userenvio'] : '';
$userrecibe = (isset($_POST['userrecibe'])) ? $_POST['userrecibe'] : '';
$titulo = (isset($_POST['titulo'])) ? $_POST['titulo'] : '';
$asunto = (isset($_POST['asunto'])) ? $_POST['asunto'] : '';
$mensaje = (isset($_POST['mensaje'])) ? $_POST['mensaje'] : '';
$mensaje2 = "Buenas, este mensaje es para solicitar el cambio de el Grupo ".$grupo." al Aula ".$aula." .Gracias.";

switch ($opcion) {
    case 1:

        $pQuery = $conexion->prepare(" call ingresar_solicitud(:gru,:au,:en,:re,:ti,:asun,:mens); ");
        $pQuery->bindParam(':gru', $grupo);
        $pQuery->bindParam(':au', $aula);
        $pQuery->bindParam(':en', $userenvio);
        $pQuery->bindParam(':re', $userrecibe);
        $pQuery->bindParam(':ti', $titulo);
         $pQuery->bindParam(':asun', $asunto);
          $pQuery->bindParam(':mens', $mensaje2);
        $pQuery->execute();
        break;
   
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
