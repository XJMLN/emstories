const spawner = new Vue({
    el: '#spawn',
    data: {
        ResourceName: "em_spawnSelection",
        showSpawner:false,
        showFaction:false,
        showDepartment:false,
        faction:'',
        playerData:false,
        newplayer:false,
    },
    methods: {
        
        OpenSpawnerMenu(data){
           this.playerData = data;
           this.showSpawner = true;
           this.showFaction = true;
           this.showDepartment = false;
           this.newplayer = data.newplayer;
        },
        showSelection(type){
            this.faction = type;
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
                    faction: faction,
                    newplayer: spawner.newplayer
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