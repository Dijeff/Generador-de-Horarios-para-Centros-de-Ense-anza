let params = new URLSearchParams(location.search);
var contract = params.get('id');


new Vue({
    el: '#app',
    vuetify: new Vuetify(),
    props: {
        defaultState: {
            type: Boolean,
            default: false
        }
    },
    data: {
        horarios: [],
        
          array: [],
          id: contract,
        snackbar: false,
        textSnack: 'texto snackbar',
        dialog: false,
        editedIndex: -1,
        editado: {
            nombre: '',
            ubicacion: '',
            cantidad: '',
            pisos: '',
            estado: '',
            foto: '',
        },
        defaultItem: {
            Nombre: '',
            Ubicacion: '',
            Cantidad: '',
            Pisos: '',
            Estado: '',
            Foto: '',
        },
        headers: [{
            text: 'Descripcion',
            align: 'left',
            sortable: false,
            value: 'descripcion',
        },
        {
            text: 'Ubicacion',
            value: 'ubicacion'
        },
        {
            text: 'Numero Aulas',
            value: 'num_aulas'
        },
        {
            text: 'Pisos',
            value: 'pisos'
        },
        {
            text: 'Estado',
            value: 'estado'
        },
        {
            text: 'foto',
            value: 'foto',
            sortable: false
        },
        ],
        tipos: ['Normal', 'Laboratorio', 'Administrativa', 'Medica', 'Publica'],
        ubi: ['1 Piso', '2 Piso'],
        editado2: {
            nombreaula: '',
            capacidad: '',
            edificio: '',
            tipo: '',
            ubicacion: '',
            estado: '',
        },
        defaultItem2: {
            Nombreaula: '',
            Capacidad: '',
            Edificio: '',
            Tipo: '',
            Ubicacion: '',
            Estado: '',
        },
        headers2: [{
            text: 'Edificio',
            align: 'left',
            sortable: false,
            value: '',
        },
        {
            text: 'Nombre Aula',
            value: 'nombreaula'
        },
        {
            text: 'Capacidad',
            value: 'capacidad'
        },
        {
            text: 'Ubicación',
            value: 'ubicacion'
        },
        {
            text: 'Tipo',
            value: 'tipo'
        },
        {
            text: 'Estado',
            value: 'estado'
        },
        {
            text: 'ACCIONES',
            value: 'accion',
            sortable: false
        },
        ],
        currentState: this.defaultState,
        codigo: contract,
        checkedNames: [],
        HorarioEstudiantes: [{
            id: 1,
            Horario: 'Lunes 8:00 - 11:40',
            Materia: 'Comunicación Oral y Escrita',
            Grupo: '1',
            Aula: 'A-16',
            Profesor: 'Pepito Profe',
            Ubicacion: 'Al lado del baño de hombres',
            Coordenadas: 'L:0 A:0',
            show: false,
            showubi: false,
            showprofe: false
        },
        {
            id: 2,
            Horario: 'Martes 8:00 - 11:40',
            Materia: 'Comunicación Oral y Escrita',
            Grupo: '2',
            Aula: 'A-17',
            Profesor: 'Pepito Profe',
            Ubicacion: 'Al lado del baño de hombres',
            Coordenadas: 'L:0 A:0',
            show: false,
            showubi: false,
            showprofe: false

        },
        {
            id: 3,
            Horario: 'Miercoles 8:00 - 11:40',
            Materia: 'Comunicación Oral y Escrita',
            Grupo: '3',
            Aula: 'A-18',
            Profesor: 'Pepito Profe',
            Ubicacion: 'Al lado del baño de hombres',
            Coordenadas: '9.861, -83.926',
            show: false,
            showubi: false,
            showprofe: false

        },
        {
            id: 4,
            Horario: 'Miercoles 8:00 - 11:40',
            Materia: 'Comunicación Oral y Escrita',
            Grupo: '3',
            Aula: 'A-18',
            Profesor: 'Pepito Profe',
            Ubicacion: 'Al lado del baño de hombres',
            Coordenadas: '9.861, -83.926',
            show: false,
            showubi: false,
            showprofe: false

        },
        ],

        InfoPofre: [{
            id: 1,
            Imagen: 'img.png',
            Nombre: 'Julio Porfe',
            Correo: 'julioprofe@cuc.cr'

        },
        {
            id: 2,
            Imagen: 'img.png',
            Nombre: 'Julio Porfe',
            Correo: 'julioprofe@cuc.cr'


        },
        {
            id: 3,
            Imagen: 'img.png',
            Nombre: 'Julio Porfe',
            Correo: 'julioprofe@cuc.cr'


        }
        ], editado: {
            id: '',
            titulo: '',
            encargado: '',
            descripcion: '',
        },
        ID: 0,
        all_data: [],
        aulas: [],
        UserName: 'Alberto',
        idhora: 0,
        switch1: false,
        Lat: 9.861,
        Long: -83.926
    },
    methods: {
        src: function () {
            return this.url = "https://maps.google.com/maps/embed/v1/place?key=AIzaSyDW6-j8S7v1SDU5nauWoBzJWqEBzRNaZm4&q=" + this.Lat + "," + this.Long + "";

        }


    },
    computed: {

        formTitle() {
            return this.editedIndex === -1 ? 'Crear Edificio' : 'Editar Edificio'
        },
        formTitle2() {
            return this.editedIndex === -1 ? 'Crear Aula' : 'Editar Aula'
        }
    },

    watch: {
        dialog(val) {
            val || this.cancelar()
        },
    },

    created() {
        this.get_contacts();
        this.listarhorario();
    },
    methods: {

        //Procedimiento Listar moviles  
         listarhorario: function () {
            fetch("../php/horarioAula.php?a=" + contract)
                .then(response => response.json())
                .then(json => { this.horarios = json.contactos })
        },
        get_contacts: function () {
            fetch("../php/edificiotarjetas.php")
                .then(response => response.json())
                .then(json => { this.all_data = json.contactos })
        },


        altaTarea: function () {
            axios.post(url, {
                opcion: 1,
                nombre: this.defaultItem.Nombre,
                ubicacion: this.defaultItem.Ubicacion,
                cantidad: this.defaultItem.Cantidad,
                pisos: this.defaultItem.Pisos,
                estado: this.defaultItem.Estado,
                foto: this.defaultItem.Foto
            }).then(response => {
                this.dialog = false;
                this.snackbar = true;
                this.textSnack = '¡Se inserto con exito!';
                this.get_contacts();
            });
            this.defaultItem.Nombre = "",
                this.defaultItem.Ubicacion = "",
                this.defaultItem.Cantidad = "",
                this.defaultItem.Pisos = "",
                this.defaultItem.Estado = "",
                this.defaultItem.Foto = "",
                this.get_contacts();
        },
        altaTarea2: function () {
            axios.post(url2, {
                opcion: 1,
                nombreaula: this.defaultItem2.Nombreaula,
                capacidad: this.defaultItem2.Capacidad,
                edificio: this.defaultItem2.Edificio,
                tipo: this.defaultItem2.Tipo,
                ubicacion: this.defaultItem2.Ubicacion,
                estado: this.defaultItem2.Estado
            }).then(response => {
                this.dialog = false;
                this.snackbar = true;
                this.textSnack = '¡Se inserto aula con exito!';
                this.listaraulas();
            });
            this.defaultItem2.Nombreaula = "",
                this.defaultItem2.Capacidad = "",
                this.defaultItem2.Edificio = "",
                this.defaultItem2.Tipo = "",
                this.defaultItem2.Ubicacion = "",
                this.defaultItem2.Estado = "",
                this.listaraulas();
        },
        editarTarea: function (ID2, Nombreaula, Capacidad, Edificio, Tipo, Ubicacion, Estado) {
            axios.post(url2, {
                opcion: 3,
                id: ID2,
                nombreaula: Nombreaula,
                capacidad: Capacidad,
                edificio: Edificio,
                tipo: Tipo,
                ubicacion: Ubicacion,
                estado: Estado
            }).then(response => {
                this.snackbar = true
                this.textSnack = 'Se actualizo aula !'
                this.listaraulas()
            });
        },


        cancelar() {
            this.dialog = false
            this.editado = Object.assign({}, this.defaultItem)
            this.editedIndex = -1
        },
        editar(item) {
            this.editedIndex = item
            this.editado = Object.assign({}, item)
            this.dialog = true
            console.log(item)
        },
        guardar() {
            if (this.editedIndex > -1) {
                //Guarda en caso de Edición
                this.defaultItem.Nombre = this.editado.nombre
                this.defaultItem.Ubicacion = this.editado.ubicacion
                this.defaultItem.Cantidad = this.editado.cantidad
                this.defaultItem.Pisos = this.editado.pisos
                this.defaultItem.Estado = this.editado.estado
                this.defaultItem.Foto = this.editado.foto
                this.snackbar = true
                this.textSnack = '¡Actualización Exitosa!'

            } else {
                //Guarda el registro en caso de Alta  

                if (this.editado.nombre == "" || this.editado.ubicacion == "" || this.editado.cantidad == "" || this.editado.pisos == "" || this.editado.estado == "" || this.editado.foto == "") {
                    this.snackbar = true
                    this.textSnack = 'Datos incompletos.'
                } else {
                    this.defaultItem.Nombre = this.editado.nombre
                    this.defaultItem.Ubicacion = this.editado.ubicacion
                    this.defaultItem.Cantidad = this.editado.cantidad
                    this.defaultItem.Pisos = this.editado.pisos
                    this.defaultItem.Estado = this.editado.estado
                    this.defaultItem.Foto = this.editado.foto
                    this.snackbar = true
                    this.textSnack = '¡Alta exitosa!'

                    this.altaTarea()
                }
            }
            this.cancelar
        },
        guardar2() {
            if (this.editedIndex > -1) {
                //Guarda en caso de Edición
                this.ID = this.editedIndex
                this.defaultItem2.Nombreaula = this.editado2.nombreaula
                this.defaultItem2.Capacidad = this.editado2.capacidad
                this.defaultItem2.Edificio = this.editado2.edificio
                this.defaultItem2.Tipo = this.editado2.tipo
                this.defaultItem2.Ubicacion = this.editado2.ubicacion
                this.defaultItem2.Estado = this.editado2.estado
                this.snackbar = true
                this.textSnack = '¡Actualización Exitosa!' 
                this.editarTarea(this.ID, this.editado2.nombreaula, this.editado2.capacidad, this.editado2.edificio, this.editado2.tipo, this.editado2.ubicacion, this.editado2.estado)
            } else {
                //Guarda el registro en caso de Alta  

                if (this.editado2.nombreaula == "" || this.editado2.capacidad == "" || this.editado2.edificio == "" || this.editado2.tipo == "" || this.editado2.ubicacion == "" || this.editado2.estado == "") {
                    this.snackbar = true
                    this.textSnack = 'Datos incompletos.'
                } else {
                    this.defaultItem2.Nombreaula = this.editado2.nombreaula
                    this.defaultItem2.Capacidad = this.editado2.capacidad
                    this.defaultItem2.Edificio = this.editado2.edificio
                    this.defaultItem2.Tipo = this.editado2.tipo
                    this.defaultItem2.Ubicacion = this.editado2.ubicacion
                    this.defaultItem2.Estado = this.editado2.estado
                    this.snackbar = true
                    this.textSnack = '¡Alta exitosa!'

                    this.altaTarea2()
                }
            }
            this.cancelar
        },

        darNombreProfe() {
            console.log(this.idhora);

            if (this.tip) {
                for (soli of this.SoliMensajes) {
                    if (soli.id == this.cod) {
                        console.log(this.cod);
                        return soli.titulo;
                    }
                }

            }
            if (!this.tip) {
                for (solis of this.VistoMensajes) {
                    if (solis.id == this.cod) {
                        console.log(this.cod);
                        return solis.titulo;
                    }
                }
            }
            return "";
        },
    }

})
