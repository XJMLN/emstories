const fuel = new Vue({
    el: '#fuel',
    data: {
        ResourceName: "em_fuel_stations",
        showFuel:false,
        fuelPrice:0.0,
        carFuel:0,
        toPay:0,
        plrMoneyState: 0,
        loadedFuel:0,
    },
    methods: {
        OpenFuelMenu(data) {
            this.showFuel = true;
            this.carFuel = data.fuel;
            this.fuelPrice = data.price;
            this.plrMoneyState = data.money;
            this.toPay = 0;
            this.loadedFuel = 0;
            jQuery("#fuelLevel").progress({percent: fuel.carFuel});
           
        },
        payAndCloseMenu(data){
            if (this.toPay == 0 && this.loadedFuel == 0) {
                this.showFuel = false;
            }
            if (this.toPay >0 || this.loadedFuel>0) {
                this.showFuel = false;
                axios.post(`https://em_fuel_stations/pay`,{
                    toPay:this.toPay,
                    fuel:this.loadedFuel,
                }).then((response)=>{}).catch((error)=>{console.log(error);});
            }
        }
    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "open_fuelMenu") {
                fuel.OpenFuelMenu(event.data.data);
            }
            if (event.data.type == "playerLeaveMarker") {
                fuel.payAndCloseMenu(event.data.data);
            }
        });
        window.addEventListener("keypress",function(e){
            if (e.key === "Enter") {
                if (fuel.carFuel <100) {
                    fuel.toPay = parseFloat(fuel.toPay + (fuel.fuelPrice));
                    if (fuel.toPay> fuel.plrMoneyState) {
                        console.log("kasy juz nie masz");
                        return;
                    } else {
                        fuel.carFuel = fuel.carFuel + 1
                        fuel.loadedFuel = fuel.loadedFuel + 1
                        jQuery("#fuelLevel").progress({percent: fuel.carFuel});
                    }
                }
                
            }
        })
    }
}