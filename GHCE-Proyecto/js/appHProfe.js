var url = "../php/HProfe.php";
let params = new URLSearchParams(location.search);
var contract = params.get('id');
new Vue({
    el: '#app',
    vuetify: new Vuetify(),
    data: {
        Horario: [],
        HorarioTodo: [],
        id: contract,
        Estudiante:[],
        EstudianteTodo:[],
        grupo:0
    },
    methods: {
        ListarHorario: function () {
            axios.post(url, {
                opcion: 1,
                id: this.id
            }).then(response => {
                this.HorarioTodo = response.data;
                console.log(this.HorarioTodo);
                this.Ordenar();
            });
          
        },
        ListarEstudiantesGrupo: function () {
            axios.post(url, {
                opcion: 2,
                id: this.id
            }).then(response => {
                this.EstudianteTodo = response.data;
                console.log(this.EstudianteTodo);
                this.OrdenarEstudua();
            });
          
        },
        Ordenar(){
            for (soli of this.HorarioTodo) {
                    
                   this.Horario.push({
                    Edificio: soli.Edificio,
                    aula: soli.descripcion,
                    materia: soli.descripcion3,
                    dia: soli.dia,
                    hora_fin: soli.hora_fin,
                    hora_inicio: soli.hora_inicio,
                    id_grupo: soli.id_grupo,
                    ubicacion: soli.ubicacion,
                    codgrupo: soli.cod_grupo,
                    show:false,
                    showEstu:false,
                    showUbi:false  
                   });
                }
        },
        OrdenarEstudua(){
            for (soli of this.EstudianteTodo) {
                    
                   this.Estudiante.push({
                    id: soli.id_persona,
                    nomb:soli.Nombre
                   });
                }
        },
    },
    computed: {
        
       

    },
    created() {
        this.ListarHorario();
    },
}, 
 )