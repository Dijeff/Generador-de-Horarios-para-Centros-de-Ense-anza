<?php

  $_POST = json_decode(file_get_contents("php://input"), true);
  
    // Envio de Correo
    $sms = (isset($_POST['sms'])) ? $_POST['sms'] : '';
    $receptor= (isset($_POST['receptor'])) ? $_POST['receptor'] : '';
    $asunto="APSW Proyecto 3";
    $headers="MIME-Version: 1.0\r\n";
    $headers.="Content-type: text/html; charset=utf-8\r\n";
    $headers.="From: APSW <apsw.proyecto3@gmail.com>\r\n";

    $exito=mail($receptor, $asunto, $sms, $headers);
    if($exito)
    {
        $data =  "Mensaje Enviado con exito";
    }else
    {
        $data = "Error al enviar el mensaje";
    }
    
   print json_encode($data, JSON_UNESCAPED_UNICODE);
?>

