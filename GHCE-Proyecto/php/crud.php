<?php
/*
* Convertir datos de la tabla contact en JSON
* Powered by @evilnapsis
$serverName = "AdminSitios.mssql.somee.com"; //serverName\instanceName
$connectionInfo = array( "Database"=>"AdminSitios", "UID"=>"GrupoSitios_SQLLogin_1", "PWD"=>"r4pxpqe3hb");
$con = sqlsrv_connect( $serverName, $connectionInfo);
*/




$con = new mysqli('AdminSitios.mssql.somee.com','GrupoSitios','r4pxpqe3hb','AdminSitios');

if($con){
	$sql = "call SP_OBTENER_ALL_AULAS();";
	$query = $con->query($sql);
	$data = array();
	while($r = $query->fetch_assoc()){
		$data[] = $r;
	}
	echo json_encode(array("contactos"=>$data));
	$con = NULL;
}
?>