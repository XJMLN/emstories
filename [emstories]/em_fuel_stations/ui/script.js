const fuel = new Vue({
    el: '#fuel',
    data: {
        ResourceName: "em_fuel_stations",
        showFuel:false,
        fuelPrice:0.0,
        carFuel:0,
        toPay:0,
    },
    methods: {
        OpenFuelMenu(data) {
            this.showFuel = true;
            this.carFuel = data.fuel;
            this.fuelPrice = data.price;
            jQuery("#fuelLevel").progress({percent: fuel.carFuel});
           
        }
    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "open_fuelMenu") {
                fuel.OpenFuelMenu(event.data.data);
            }
        });
        window.addEventListener("keypress",function(e){
            if (e.key === "Enter") {
                if (fuel.carFuel <100) {
                    fuel.carFuel = fuel.carFuel + 1
                    jQuery("#fuelLevel").progress({percent: fuel.carFuel});
                }
                
            }
        })
    }
}