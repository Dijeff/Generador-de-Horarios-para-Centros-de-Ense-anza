
<?php
include_once 'leerExcell.php';
include_once 'conecBD.php';
$objeto = new Conexion();
$conexion = $objeto->Conectar();


$directorio = "../archivos/";
$archivnom = $_FILES["file"]["name"];
$archivo = $directorio . basename($_FILES["file"]["name"]);
$tipoArchivo = strtolower(pathinfo($archivo, PATHINFO_EXTENSION));

if ($tipoArchivo == "xlsx") {

  if (move_uploaded_file($_FILES["file"]["tmp_name"], $archivo)) {
    echo "El archvio se subio correctamente";
  } else {
    echo "Error al subir archivo";
  }
} else {
  echo "Solo se reciben archivos xlsx (archivos Excel)";
}

if ($xlsx = SimpleXLSX::parse($archivo)) {
  echo '<table><tbody>';
  $i = 0;

  foreach ($xlsx->rows() as $elt) {
    if ($elt[0] == '') {
    } else {
      if ($i == 0) {
        echo "<tr><th>" . $elt[0] . "</th><th>" . $elt[1] . "</th><th>" . $elt[2] . "</th><th>" . $elt[3] . "</th><th>" . $elt[4] . "</th><<th>" . $elt[5] . "</th><th>" . $elt[6] . "</th><th>" . $elt[7] . "</th><th>" . $elt[8] . "</th><th>" . $elt[9] . "</th><th>" . $elt[10] . "</th><th>" . $elt[11] . "</th><th>" . $elt[12] . "</th>/tr>";
      } else {
        echo "<tr><th>" . $elt[0] . "</th><th>" . $elt[1] . "</th><th>" . $elt[2] . "</th><th>" . $elt[3] . "</th><th>" . $elt[4] . "</th><<th>" . $elt[5] . "</th><th>" . $elt[6] . "</th><th>" . $elt[7] . "</th><th>" . $elt[8] . "</th><th>" . $elt[9] . "</th><th>" . $elt[10] . "</th><th>" . $elt[11] . "</th><th>" . $elt[12] . "</th>/tr>";
        //Insertamos carreras nuevas si lo permite
        $sql = 'CALL InsertarCarreras(:descripcion)';
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(':descripcion', $elt[3], PDO::PARAM_STR, 100);
        $stmt->execute();
        $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query
        //Insertamos cursos de carreras
        $sql = 'CALL 	InsertarCursos(:cod,:des,:car)';
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(':cod', $elt[0], PDO::PARAM_STR, 100);
        $stmt->bindParam(':des', $elt[1], PDO::PARAM_STR, 100);
        $stmt->bindParam(':car', $elt[3], PDO::PARAM_STR, 100);
        $stmt->execute();
        $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query

        $sql = 'CALL 	agregarOferta(:nom,:arch,:ini,:fin)';
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(':nom', $archivnom, PDO::PARAM_STR, 100);
        $stmt->bindParam(':arch', $archivo, PDO::PARAM_STR, 100);
        //Fecha Inicio
        $inicio = strtotime($elt[4]);
        $fechaini = (int)$inicio;

        $days = floor($fechaini / 86400);
        $time = round((($fechaini / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);

        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $newDate = $dateObj->format('Y-m-d');
        $fechaInicial = date("Y-m-d", strtotime($newDate . "+ 1 days"));
        //Fecha Fin
        $fin = strtotime($elt[5]);
        $fechafi = (int)$fin;

        $days = floor($fechafi / 86400);
        $time = round((($fechafi / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);

        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $newDate = $dateObj->format('Y-m-d');
        $fechaFinal = date("Y-m-d", strtotime($newDate . "+ 1 days"));



        $stmt->bindParam(':ini', $fechaInicial, PDO::PARAM_STR, 100);
        $stmt->bindParam(':fin', $fechaFinal, PDO::PARAM_STR, 100);
        $stmt->execute();
        $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query

        //Agregar periodo

        $sql = 'CALL 	AgregarPeriodo(:ini,:fin)';
        $stmt = $conexion->prepare($sql);
        //Fecha Inicio
        $inicio = strtotime($elt[4]);
        $fechaini = (int)$inicio;

        $days = floor($fechaini / 86400);
        $time = round((($fechaini / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);

        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $newDate = $dateObj->format('Y-m-d');
        $fechaInicial = date("Y-m-d", strtotime($newDate . "+ 1 days"));
        //Fecha Fin
        $fin = strtotime($elt[5]);
        $fechafi = (int)$fin;

        $days = floor($fechafi / 86400);
        $time = round((($fechafi / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);

        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $newDate = $dateObj->format('Y-m-d');
        $fechaFinal = date("Y-m-d", strtotime($newDate . "+ 1 days"));

        $stmt->bindParam(':ini', $fechaInicial, PDO::PARAM_STR, 100);
        $stmt->bindParam(':fin', $fechaFinal, PDO::PARAM_STR, 100);
        $stmt->execute();
        $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query


        //Agregar horario
        $sql = 'CALL 	agregarhorariop(:dian,:inicio,:fin,:cod,:fechaI,:fechaF)';
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(':dian', $elt[9], PDO::PARAM_STR, 100);
        $stmt->bindParam(':cod', $archivnom, PDO::PARAM_STR, 100);
        //Fecha Inicio
        $inicio = strtotime($elt[10]);
        $fechaini = (int)$inicio;

        $days = floor($fechaini / 86400);
        $time = round((($fechaini / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);
        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $fechaInicial = $dateObj->format('H:i:s');

        $fechaInicial = date_create($fechaInicial);
        date_time_set($fechaInicial, $hours, $minutes, $seconds);
        $fechaInicial->modify("+1 hour");
        $fechaInicial = $fechaInicial->format('H:i:s');

        //Fecha Fin
        $fin = strtotime($elt[11]);
        $fechafi = (int)$fin;

        $days = floor($fechafi / 86400);
        $time = round((($fechafi / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);
        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');


        $fechaFinal = date_create($fechaFinal);
        date_time_set($fechaFinal, $hours, $minutes, $seconds);
        $fechaFinal->modify("+1 hour");
        $fechaFinal = $fechaFinal->format('H:i:s');

        $stmt->bindParam(':inicio', $fechaInicial, PDO::PARAM_STR, 100);
        $stmt->bindParam(':fin', $fechaFinal, PDO::PARAM_STR, 100);
        
        $inicio = strtotime($elt[4]);
        $fechaini = (int)$inicio;

        $days = floor($fechaini / 86400);
        $time = round((($fechaini / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);

        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $newDate = $dateObj->format('Y-m-d');
        $fechaInicialf = date("Y-m-d", strtotime($newDate . "+ 1 days"));
        //Fecha Fin
        $fin = strtotime($elt[5]);
        $fechafi = (int)$fin;

        $days = floor($fechafi / 86400);
        $time = round((($fechafi / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);

        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $newDate = $dateObj->format('Y-m-d');
        $fechaFinalf = date("Y-m-d", strtotime($newDate . "+ 1 days"));

        $stmt->bindParam(':fechaI', $fechaInicialf, PDO::PARAM_STR, 100);
        $stmt->bindParam(':fechaF', $fechaFinalf, PDO::PARAM_STR, 100);
        $stmt->execute();
        $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query


        //Agregar grupo
        $sql = 'CALL 	AgregarGrupo(:des,:tamano,:dian,:horaini,:horafin,:nomb_pro,:curso,:id)';
        $stmt = $conexion->prepare($sql);
        $stmt->bindParam(':des', $elt[1], PDO::PARAM_STR, 100);
        $stmt->bindParam(':tamano', $elt[7], PDO::PARAM_STR, 100);
        $stmt->bindParam(':dian', $elt[9], PDO::PARAM_STR, 100);
        $stmt->bindParam(':nomb_pro', $elt[12], PDO::PARAM_STR, 100);
        $stmt->bindParam(':curso', $elt[0], PDO::PARAM_STR, 100);
        $stmt->bindParam(':id', $elt[2], PDO::PARAM_STR, 100);
        //Fecha Inicio
        $inicio = strtotime($elt[10]);
        $fechaini = (int)$inicio;

        $days = floor($fechaini / 86400);
        $time = round((($fechaini / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);
        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');
        $fechaInicial = $dateObj->format('H:i:s');

        $fechaInicial = date_create($fechaInicial);
        date_time_set($fechaInicial, $hours, $minutes, $seconds);
        $fechaInicial->modify("+1 hour");
        $fechaInicial = $fechaInicial->format('H:i:s');

        //Fecha Fin
        $fin = strtotime($elt[11]);
        $fechafi = (int)$fin;

        $days = floor($fechafi / 86400);
        $time = round((($fechafi / 86400) - $days) * 86400);
        $hours = round($time / 3600);
        $minutes = round($time / 60) - ($hours * 60);
        $seconds = round($time) - ($hours * 3600) - ($minutes * 60);
        $dateObj = date_create('1-Jan-1970+' . $days  . ' days');


        $fechaFinal = date_create($fechaFinal);
        date_time_set($fechaFinal, $hours, $minutes, $seconds);
        $fechaFinal->modify("+1 hour");
        $fechaFinal = $fechaFinal->format('H:i:s');

        $stmt->bindParam(':horaini', $fechaInicial, PDO::PARAM_STR, 100);
        $stmt->bindParam(':horafin', $fechaFinal, PDO::PARAM_STR, 100);
        $stmt->execute();
        $stmt->closeCursor(); //permite limpiar y ejecutar la segunda query




      }
    }




    $i++;
  }




  echo "</tbody></table>";
} else {
  echo SimpleXLSX::parseError();
}



?>