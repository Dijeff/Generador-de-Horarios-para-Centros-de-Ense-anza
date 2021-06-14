var url = "../php/LoginBD.php";

new Vue({
  el: '#app',
  vuetify: new Vuetify(),
  data: {
    id: '',
    contra: '',
    resp: {
      nombre: ''
    },
    dire: '',
    textSnack: '',
    snackbar: false,
    color: '',
    Info: {
      Id: '',
      Contra: ''
    }
  },
  methods: {
    ValidarUser: function () {
      axios.post(url, {
        opcion: 1,
        id: this.Info.Id,
        contra: this.Info.Contra,
      }).then(response => {
        this.resp = response.data;
        console.log(this.resp[0].nombre);
        if (this.resp[0].nombre == 1) {
          this.dire = "HorarioProfe.html?id="+this.Info.Id;
          this.enviarPagina();
        } else if (this.resp[0].nombre == 2) {
          this.dire = "HorarioEst.html?id="+this.Info.Id;
          this.snackbar = true
          this.textSnack = 'Inicio de sesion estudiante.'
          this.color = true
          this.enviarPagina();
        } else if (this.resp[0].nombre == 3) {
          this.dire = "VistaOferta.html?id="+this.Info.Id;
          this.snackbar = true
          this.textSnack = 'Inicio de sesion encargado de la oferta academica.'
          this.color = true
          this.enviarPagina();
        } else if (this.resp[0].nombre == 4) {
          this.dire = "grupos.html?id="+this.Info.Id;
          this.snackbar = true
          this.textSnack = 'Inicio de sesion encargado de distribucion.'
          this.color = true
          this.enviarPagina();
        } else if (this.resp[0].nombre == 5) {
          this.dire = "Solicitudes.php?id="+this.Info.Id;
          this.snackbar = true
          this.textSnack = 'Inicio de sesion director de carrera.'
          this.color = true
          this.enviarPagina();
        } else if (this.resp[0].nombre == 10) {
          this.snackbar = true
          this.textSnack = 'Inicio de sesion incorrecto.'
          this.color = false
        }
       
      });

    },

    guardar() {
      this.Info.Id = this.id
      this.Info.Contra = this.contra
      this.ValidarUser()
    },
    enviarPagina(){
      window.location.href = '../html/'+this.dire;
    }


  },
  computed: {

  }
}, )