const spawner = new Vue({
    el: '#spawn',
    data: {
        ResourceName: "em_spawnSelection",
        showSpawner:false,
        showFaction:false,
        showDepartment:false,
        faction:'',
        newplayer:false,
        factionName: ' ',
    },
    methods: {
        
        OpenSpawnerMenu(data){
           this.showSpawner = true;
           var audio = document.getElementById("audio");
           audio.volume = 0.1;
           audio.play();
           this.showFaction = true;
           this.showDepartment = false;
           this.newplayer = data
        },
        changeText(name){
            this.factionName = name;
        },
        returnSelection(){
            this.faction = '';
            this.showDepartment = false;
            this.showFaction = true;
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
            var audio = document.getElementById("audio")
            audio.pause();
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