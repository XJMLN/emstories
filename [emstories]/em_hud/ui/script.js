const HUD = new Vue({
    el: '#hud',
    data: {
        ResourceName: "em_hud",
        showHUD:false,
        street:"",
        zone:"",
    },
    methods: {
        
        renderHUD(){
            this.showHUD = true
        },

        updateStreet(data) {
            if (data.street){
                this.street=data.street;
            }else {
                this.street="";
            }
            this.zone=data.zone;
            
        }
        

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "drawHUD") {
                HUD.renderHUD();
            }
            if (event.data.type == "streetUpdate") {
                HUD.updateStreet(event.data.data);
            }
        });
    }
}