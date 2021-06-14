<?php
include_once 'conecBD.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

$_POST = json_decode(file_get_contents("php://input"), true);
$opcion = (isset($_POST['opcion'])) ? $_POST['opcion'] : '';
$id = (isset($_POST['id'])) ? $_POST['id'] : '';
$cod = (isset($_POST['cod'])) ? $_POST['cod'] : '';
$est = (isset($_POST['est'])) ? $_POST['est'] : '';
$aula = (isset($_POST['aula'])) ? $_POST['aula'] : '';
$grupo = (isset($_POST['grupo'])) ? $_POST['grupo'] : '';


switch ($opcion) {
    case 1:
        try {
            $sql = 'CALL sp_SolicitudesConsultar(:id_director)';
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

            $resultado->closeCursor(); 
            $consulta = "INSERT INTO grupo_x_aula (cod_aula, cod_grupo) VALUES('$aula', '$grupo') ";
            $resultado = $conexion->prepare($consulta);
            $resultado->execute();

        } catch (PDOException $pe) {
            die("Error occurred:" . $pe->getMessage());
        }
        break;
}
print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
