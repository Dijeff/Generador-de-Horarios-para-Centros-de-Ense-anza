var url = "../php/SolicitudesBD.php";
var urlEnvio = "../php/enviocorreo.php"
let params = new URLSearchParams(location.search);
var contract = params.get('id');


new Vue({
    el: '#app',
    vuetify: new Vuetify(),
    data: {
        
         EnvioSMS: {
            sms: '',
            receptor:''
        },
        RespuestaCorreo: {
            receptor: ''
        },
        Resultado: {
            respuesta:''
        },

        SoliMensajes: [],
        AceptadoMensajes: [],
        DenegadoMensajes: [],
        NuevosMensajes: [],
        id: contract,
        dialog: false,
        visto: 1,
        est:0,
        cod: 0,
        tip: 0,
        aula: 0,
        grupo: 0,
        snackbar: false, //para el mensaje del snackbar   
        textSnack: 'texto snackbar', //texto que se ve en el snackbar 
    },
    methods: {
        
         EnviarCorreo: function(){
            axios.post(urlEnvio,{
                sms: this.EnvioSMS.sms,
                receptor: this.EnvioSMS.receptor
            }).then(response => {
                this.Resultado= response.data;
            })
        }, 

        enviarAceptado(){
            this.EnvioSMS.receptor = "lbrenesv.apsw3@yahoo.com";
            this.EnvioSMS.sms = "Se ha aceptado la solicitud de cambio de grupo a aula en especifico";
            //this.CorreoDistribuidor()
            this.EnviarCorreo()
            
             this.EnvioSMS.receptor = "smirandam.apsw3@yahoo.com";
            this.EnvioSMS.sms = "Se ha aceptado la solicitud de cambio de grupo a aula en especifico";
            //this.CorreoDirector()
            this.EnviarCorreo()
        },
        
         enviarDenegacion(){
            this.EnvioSMS.receptor = "lbrenesv.apsw3@yahoo.com";
            this.EnvioSMS.sms = "Se ha denegado la solicitud de cambio de grupo a aula en especifico";
            //this.CorreoDistribuidor()
            this.EnviarCorreo()
            
             this.EnvioSMS.receptor = "smirandam.apsw3@yahoo.com";
            this.EnvioSMS.sms = "Se ha denegado la solicitud de cambio de grupo a aula en especifico";
            //this.CorreoDirector()
            this.EnviarCorreo()
        },

        aceptarSolicitud() {

            this.snackbar = true
            this.textSnack = 'Se acepto la solicitud.'
            this.AceptarSolicitudfun();
            this.enviarAceptado();
        },
        denegarSolicitud() {

            this.snackbar = true
            this.textSnack = 'Se denego la solicitud.'
            this. DenegarSolicitudfun();
             this.enviarDenegacion();
        },
        ListarMensajes: function () {
            axios.post(url, {
                opcion: 1,
                id: this.id
            }).then(response => {
                this.SoliMensajes = response.data;
                console.log(this.SoliMensajes);
                this.filtrarSolicitudes();
            });
           
        },
       AceptarSolicitudfun: function() {
            console.log("Entro a aceptar");
            this.est = '2'
            console.log(this.cod +" "+this.est+" "+this.aula+" "+this.grupo);
            axios.post(url, {
                opcion: 2,
                cod: this.cod,
                est: this.est,
                aula: this.aula,
                grupo: this.grupo
            }).then(response => {
                console.log(response.data);
                this.filtrarSolicitudes();
            });
            window.location.href = '../html/Solicitudes.html?id='+this.id;
        },
        DenegarSolicitudfun: function() {
            console.log("Entro a denegar");
            this.est = '3'
            console.log(this.cod +" "+this.est+" "+this.aula+" "+this.grupo);
           axios.post(url, {
                opcion: 2,
                cod: this.cod,
                est: this.est,
                aula: this.aula,
                grupo: this.grupo
            }).then(response => {
                console.log(response.data);
                this.filtrarSolicitudes();
            });
            window.location.href = '../html/Solicitudes.php?id='+this.id;
        },
        filtrarSolicitudes() {
            console.log(this.SoliMensajes);
            for (soli of this.SoliMensajes) {

                 if(soli.estado == 1) {
                     
                    this.NuevosMensajes.push({
                        cod_solicitud: soli.cod_solicitud,
                        titulo: soli.titulo,
                        asunto: soli.asunto,
                        mensaje: soli.mensaje,
                        user_envio: soli.user_envio,
                        user_recibo: soli.user_recibo,
                        estado: soli.estado,
                        aula: soli.aula,
                        grupo: soli.grupo
                    });
                }else if(soli.estado == 2){
                    this.AceptadoMensajes.push({
                        cod_solicitud: soli.cod_solicitud,
                        titulo: soli.titulo,
                        asunto: soli.asunto,
                        mensaje: soli.mensaje,
                        user_envio: soli.user_envio,
                        user_recibo: soli.user_recibo,
                        estado: soli.estado,
                        aula: soli.aula,
                        grupo: soli.grupo
                    });
                }else if(soli.estado == 3){
                    this.DenegadoMensajes.push({
                        cod_solicitud: soli.cod_solicitud,
                        titulo: soli.titulo,
                        asunto: soli.asunto,
                        mensaje: soli.mensaje,
                        user_envio: soli.user_envio,
                        user_recibo: soli.user_recibo,
                        estado: soli.estado,
                        aula: soli.aula,
                        grupo: soli.grupo
                    });
                }
            }
        console.log(this.DenegadoMensajes);
        console.log(this.AceptadoMensajes);    
    },


    },
    computed: {

        darTitulo() {
            console.log(this.tip);

            if (this.tip == 1) {
                for (soli of this.NuevosMensajes) {
                    if (soli.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.titulo;
                    }
                }

            }
            if (this.tip == 2) {
                for (solis of this.AceptadoMensajes) {
                    if (solis.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.titulo;
                    }
                }
            }
            if (this.tip == 3) {
                for (solis of this.DenegadoMensajes) {
                    if (solis.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.titulo;
                    }
                }
            }
            return "";
        },
        darAsunto() {
            console.log(this.tip);

            if (this.tip == 1) {
                for (soli of this.NuevosMensajes) {
                    if (soli.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.asunto;
                    }
                }

            }
            if (this.tip == 2) {
                for (solis of this.AceptadoMensajes) {
                    if (solis.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.asunto;
                    }
                }
            }
            if (this.tip == 3) {
                for (solis of this.DenegadoMensajes) {
                    if (solis.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.asunto;
                    }
                }
            }
            return "";
        },
        darDescripc() {
            console.log(this.tip);

            if (this.tip == 1) {
                for (soli of this.NuevosMensajes) {
                    if (soli.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.mensaje;
                    }
                }

            }
            if (this.tip == 2) {
                for (solis of this.AceptadoMensajes) {
                    if (solis.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.mensaje;
                    }
                }
            }
            if (this.tip == 3) {
                for (solis of this.DenegadoMensajes) {
                    if (solis.cod_solicitud == this.cod) {
                        console.log(this.cod);
                        return soli.mensaje;
                    }
                }
            }
            return "";
        },
    },
    created() {
        this.ListarMensajes();
    },
}, )