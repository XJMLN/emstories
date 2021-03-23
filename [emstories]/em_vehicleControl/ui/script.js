var icon = {
    cross: "M24.778,21.419 19.276,15.917 24.777,10.415 21.949,7.585 16.447,13.087 10.945,7.585 8.117,10.415 13.618,15.917 8.116,21.419 10.946,24.248 16.447,18.746 21.948,24.248z",
};

const vehControl = new Vue({
    el: '#vehicleControls',
    data: {
        resourceName: "em_vehicleControl",
        isOpened: false,
        wheel: false,
        description: '',
    },
    methods: {
        CreateControls(data){
            this.isOpened = true;
            this.wheel = new wheelnav('interaction',null);
            this.wheel.spreaderEnable = true;
            this.wheel.wheelRadius = 200;
            this.wheel.spreaderRadius = 50;
            this.wheel.spreaderOutTitleHeight = 25;
            this.wheel.spreaderInTitleHeight = 25;
            this.wheel.slicePathFunction = slicePath().DonutSlice;
            this.wheel.clickModeRotate = false;
            this.wheel.colors = ['#424242']
            this.wheel.titleWidth = 40
            this.wheel.titleHeight = 40
            this.wheel.spreaderOutTitle = icon.cross;
            var iconWindow = "imgsrc:images/windows-"+data.passengerWind+".png";
            var iconEngine = "imgsrc:images/engine-"+data.engine+".png";
            var iconTrunk = "imgsrc:images/trunk-"+data.trunk+".png"
            var iconBonnet = "imgsrc:images/bonnet-"+data.bonnet+".png"
            var iconDome = "imgsrc:images/dome-"+data.dome+".png"
            this.wheel.createWheel([iconEngine, iconWindow,iconTrunk,iconBonnet,iconDome ]);
            console.log(data)
            this.wheel.navItems[0].selected = false;
            this.wheel.navItems[1].selected = false;
            this.wheel.navItems[2].selected = false;
            this.wheel.navItems[3].selected = false;
            this.wheel.navItems[4].selected = false;

            this.wheel.navItems[0].navSlice.mousedown(function() {
                axios.post(`https://em_vehicleControl/action`,{type:"engine",state:data.engine}).then((response)=>{
            }).catch((error)=>{console.log(error)});})
            this.wheel.navItems[1].navSlice.mousedown(function() {
                axios.post(`https://em_vehicleControl/action`,{type:"window",state:data.passengerWind}).then((response)=>{
            }).catch((error)=>{console.log(error)});})
            this.wheel.navItems[2].navSlice.mousedown(function() {
                axios.post(`https://em_vehicleControl/action`,{type:"trunk",state:data.trunk}).then((response)=>{
            }).catch((error)=>{console.log(error)});})
            this.wheel.navItems[3].navSlice.mousedown(function() {
                axios.post(`https://em_vehicleControl/action`,{type:"bonnet",state:data.bonnet}).then((response)=>{
            }).catch((error)=>{console.log(error)});})
            this.wheel.navItems[4].navSlice.mousedown(function() {
                axios.post(`https://em_vehicleControl/action`,{type:"dome",state:data.dome}).then((response)=>{
            }).catch((error)=>{console.log(error)});})

            this.wheel.navItems[0].navSlice.mouseover(function(){
                if (data.engine<1) {
                    vehControl.description = 'Włącz silnik';
                }else {
                    vehControl.description = "Wyłącz silnik";
                }
            })
            this.wheel.navItems[0].navSlice.mouseout(function(){
                vehControl.description = "";
            })
            this.wheel.navItems[1].navSlice.mouseover(function(){
                if (data.passengerWind<1) {
                    vehControl.description = 'Zsuń szyby';
                }else {
                    vehControl.description = "Zasuń szyby";
                }
            })
            this.wheel.navItems[1].navSlice.mouseout(function(){
                vehControl.description = "";
            })
            this.wheel.navItems[2].navSlice.mouseover(function(){
                if (data.trunk<1) {
                    vehControl.description = 'Otwórz bagażnik';
                }else {
                    vehControl.description = "Zamknij bagażnik";
                }
            })
            this.wheel.navItems[2].navSlice.mouseout(function(){
                vehControl.description = "";
            })
            this.wheel.navItems[3].navSlice.mouseover(function(){
                if (data.bonnet<1) {
                    vehControl.description = 'Otwórz maskę';
                }else {
                    vehControl.description = "Zamknij maskę";
                }
            })
            this.wheel.navItems[3].navSlice.mouseout(function(){
                vehControl.description = "";
            })
            this.wheel.navItems[4].navSlice.mouseover(function(){
                if (data.dome<1) {
                    vehControl.description = 'Włącz światło w środku';
                }else {
                    vehControl.description = "Wyłącz światło w środku";
                }
            })
            this.wheel.navItems[4].navSlice.mouseout(function(){
                vehControl.description = "";
            })
            this.wheel.refreshWheel();


            var wheelspreader = document.getElementById("wheelnav-interaction-spreader");
            var wheelspreadertitle = document.getElementById("wheelnav-interaction-spreadertitle");
            wheelspreader.onmouseup = function() {
                axios.post(`https://em_vehicleControl/none`,{type:"none"}).then((response)=>{}).catch((error)=>{console.log(error)});}
            wheelspreadertitle.onmouseup = function() {
                axios.post(`https://em_vehicleControl/none`,{type:"none"}).then((response)=>{}).catch((error)=>{console.log(error)});}
        },
        destroyControls() {
            this.isOpened = false
            this.wheel.removeWheel();
            this.description = "";
        },

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "renderVehicleControl") {
                vehControl.CreateControls(event.data.data)
            }
            if (event.data.type == "destroyInstance") {
                vehControl.destroyControls()
            }
        });
    }
}