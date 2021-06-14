<?php
include_once 'conecBD.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';
$id = (isset($_POST['id'])) ? $_POST['id'] : '';
$contra = (isset($_POST['contra'])) ? $_POST['contra'] : '';


switch ($opcion) {
    case 1:
        try {
            $sql = 'CALL sp_Login(:id,:contra,@sal)';
            $stmt = $conexion->prepare($sql);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT, 100);
            $stmt->bindParam(':contra', $contra, PDO::PARAM_STR, 100);
            $stmt->execute();
            $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query
            $consulta = "SELECT @sal as nombre";
            $resultado = $conexion->prepare($consulta);
            $resultado->execute();
            $data = $resultado->fetchAll(PDO::FETCH_ASSOC);
          
        } catch (PDOException $pe) {
            die("Error occurred:" . $pe->getMessage());
        }
        break;
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
