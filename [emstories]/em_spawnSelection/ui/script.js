const spawner = new Vue({
    el: '#spawn',
    data: {
        ResourceName: "em_spawnSelection",
        showSpawner:false,
        showFaction:false,
        showDepartment:false,
        faction:'',
    },
    methods: {
        
        OpenSpawnerMenu(){
           
           this.showSpawner = true;
           this.showFaction = true;
           this.showDepartment = false;
        },
        showSelection(type){
            this.faction = type;
            if (type == 'fd') {
                //jQuery("#double").css("background","linear-gradient(-45deg,#b82e1f,#000000)");
            }
            this.showFaction = false;
            this.showDepartment = true;
        },
         spawnPlayer(number){
            this.showSpawner = false;
            this.showFaction = false;
            this.showDepartment = false;
            this.faction = '';
            //jQuery("#double").css("background","");
            axios.post(`https://em_spawnSelection/spawnPlayer`,{
                    spawnNumber: number,
                }).then((response)=>{
                }).catch((error)=>{
                    console.log(error);
                });
        }
        

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "open_spawnSelector") {
                spawner.OpenSpawnerMenu();
            }
        });
    }
}