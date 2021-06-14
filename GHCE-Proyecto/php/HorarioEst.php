<?php
include_once 'conecBD.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();

//$a=$_GET['a'];

$_POST = json_decode(file_get_contents("php://input"), true);
$id = (isset($_POST['id'])) ? $_POST['id'] : '';

try{
    $sql = 'CALL sp_HorarioEstudiante(:id)';
	$query = $conexion->prepare($sql);
	$query->bindParam(':id', $id, PDO::PARAM_INT, 100);
	$query->execute();
	$data = $query->fetchAll(PDO::FETCH_ASSOC);
    
}catch (PDOException $pe) 
{
    die("Error occurred:" . $pe->getMessage());
}



print json_encode($data, JSON_UNESCAPED_UNICODE);
$conexion = NULL;
?>