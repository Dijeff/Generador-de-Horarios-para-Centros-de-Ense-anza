var url = "../php/verOferta.php"
var urlEnvio = "../php/enviocorreo.php"
new Vue({
    el: '#app',
    vuetify: new Vuetify(),
    data() {
        return{
            dialog: false,
            ofertas:[],
            oferta:{
               },
               
            EnvioSMS: {
            sms: '',
            receptor:''
            },
        Resultado: {
            respuesta:''
            }  
        }
         
        
    },
    created(){
        this.mostraOfera()
    },

    methods: {     
        //Metodo para visualizar la oferta
        mostraOfera:function(){
            axios.post(url,{opcion:1})
            .then(response => {
               this.ofertas = response.data;
            } )
        },
        EnviarCorreo: function(){
            axios.post(urlEnvio,{
                sms: this.EnvioSMS.sms,
                receptor: this.EnvioSMS.receptor
            }).then(response => {
                this.Resultado= response.data;
            })
        }, 
        
         enviarcorreo(){
            this.EnvioSMS.receptor = "parcem.aspw3@gmail.com";
            this.EnvioSMS.sms = "Se ha cargado una nueva oferta";
            //this.CorreoOferta()
            this.EnviarCorreo()
            
             this.EnvioSMS.receptor = "lbrenesv.apsw3@yahoo.com";
            this.EnvioSMS.sms = "Se ha cargado una nueva oferta";
            //this.CorreoDistribuidor()
            this.EnviarCorreo()
            
        },
    },
    computed: {
       
    },
    created() {
        this.mostraOfera();
    },
}, )