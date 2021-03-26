const spawner = new Vue({
    el: '#spawn',
    data: {
        ResourceName: "em_spawnSelection",
        showSpawner:false,
        showFaction:false,
        showDepartment:false,
        faction:'',
        playerData:false,
    },
    methods: {
        
        OpenSpawnerMenu(data){
           this.playerData = data;
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
         spawnPlayer(faction,number){
            this.showSpawner = false;
            this.showFaction = false;
            this.showDepartment = false;
            this.faction = '';
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
                spawner.OpenSpawnerMenu(event.data.data);
            }
        });
    }
}