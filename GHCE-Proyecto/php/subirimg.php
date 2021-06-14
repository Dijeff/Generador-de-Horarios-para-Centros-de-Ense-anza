
<?php

$directorio = "../img/";
$archivnom = $_FILES["file"]["name"];
$archivo = $directorio . basename($_FILES["file"]["name"]);
$tipoArchivo = strtolower(pathinfo($archivo, PATHINFO_EXTENSION));

if ($tipoArchivo == "jpg" or $tipoArchivo == "png") {

 move_uploaded_file($_FILES["file"]["tmp_name"], $archivo);
 echo "<script type='text/javascript'>";
    echo "window.history.back(-1)";
    echo "</script>";
}
 
?>