<?php
/*
* Convertir datos de la tabla contact en JSON
* Powered by @evilnapsis
*/
$con = new mysqli('localhost','id15465931_sa','$NV9<X$uerA8B>1J','id15465931_apswbd');


if($con){
	$sql = "call listar_grupos();";
	$query = $con->query($sql);
	$data = array();
	while($r = $query->fetch_assoc()){
		$data[] = $r;
	}
	echo json_encode(array("contactos"=>$data));
	$con = NULL;
}
?>