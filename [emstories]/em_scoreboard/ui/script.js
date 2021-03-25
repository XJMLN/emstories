const scoreboard = new Vue({
    el: '#scoreboard',
    data: {
        ResourceName: "em_scoreboard",
        showScoreboard: false,
        playerList:null,
    },
    methods: {
        
        scoreboardToggle(){
            if (this.showScoreboard){
                this.showScoreboard = false;
            }else {
                this.showScoreboard = true;
            }
        },
        updatePlayerList(data){
            this.playerList = data;
        }
    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "toggle") {
                scoreboard.scoreboardToggle();
            }
            if (event.data.type == "updatePlayerList") {
                scoreboard.updatePlayerList(event.data.data)
            }
        });
    }
}