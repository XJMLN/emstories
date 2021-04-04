const HUD = new Vue({
    el: '#hud',
    data: {
        ResourceName: "em_hud",
        showHUD:false,
        street:"",
        zone:"",
        money:0,
        vehicle:false,
        speed:"",
        fuel:"",
        department:"",
        rank:"",
        xp:0,
        showAllData:true
    },
    methods: {
        
        renderHUD(data){
            this.showHUD = true
            this.showAllData = data.showAllData
        },

        updateStreet(data) {
            if (data.street){
                this.street=data.street;
            }else {
                this.street="";
            }
            this.money = data.money;
            this.zone=data.zone;
            
        },
        updateVehicle(data) {
            if (data.vehicle) {
                this.vehicle = true;
                this.speed = data.speed;
                this.fuel = data.fuel;
            } else {
                this.vehicle = false;
                this.speed = "";
                this.fuel = "";
            }
        },
        updateFaction(data) {
            this.department = data.department;
            this.showAllData = true;
            this.rank = data.rank;
            this.xp = data.xp;
            jQuery("#xpBar").progress({percent: (data.xp*100)/2000});
        },
        updateXP(data) {
            this.xp = data.xp;
            jQuery("#xpBar").progress({percent: (data.xp*100)/2000});
        }
        

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "drawHUD") {
                HUD.renderHUD(event.data.data);
            }
            if (event.data.type == "streetUpdate") {
                HUD.updateStreet(event.data.data);
            }
            if (event.data.type == "updateFaction"){
                HUD.updateFaction(event.data.data);
            }
            if (event.data.type == "updateVehicle") {
                HUD.updateVehicle(event.data.data)
            }
            if (event.data.type == "updateXP") {
                HUD.updateXP(event.data.data);
            }
        });
    }
}