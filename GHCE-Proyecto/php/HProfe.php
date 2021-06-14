<?php
include_once 'conecBD.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';
$id = (isset($_POST['id'])) ? $_POST['id'] : '';
$gru = (isset($_POST['gru'])) ? $_POST['gru'] : '';

switch ($opcion) {
    case 1:
        try {
            $sql = 'CALL sp_HorarioProfe(:id_director)';
            $resultado = $conexion->prepare($sql);
            $resultado->bindParam(':id_director', $id, PDO::PARAM_INT, 100);
            $resultado->execute();
            $data = $resultado->fetchAll(PDO::FETCH_ASSOC);
          
        } catch (PDOException $pe) {
            die("Error occurred:" . $pe->getMessage());
        }
        break;
    case 2:
        try {
            $sql = 'CALL sp_SolicitudesEditar(:cod,:est)';
            $resultado = $conexion->prepare($sql);
            $resultado->bindParam(':cod', $cod, PDO::PARAM_INT, 100);
            $resultado->bindParam(':est', $est, PDO::PARAM_INT, 100);
            $resultado->execute();
          
        } catch (PDOException $pe) {
            die("Error occurred:" . $pe->getMessage());
        }
        break;
    case 3:
        try {
            $sql = 'CALL sp_ListarEstudiantesGrupo(:gru)';
            $resultado = $conexion->prepare($sql);
            $resultado->bindParam(':gru', $gru, PDO::PARAM_INT, 100);
            $resultado->execute();
            $data = $resultado->fetchAll(PDO::FETCH_ASSOC);
          
        } catch (PDOException $pe) {
            die("Error occurred:" . $pe->getMessage());
        }
    break;
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
