var icon = {
    cross: "M24.778,21.419 19.276,15.917 24.777,10.415 21.949,7.585 16.447,13.087 10.945,7.585 8.117,10.415 13.618,15.917 8.116,21.419 10.946,24.248 16.447,18.746 21.948,24.248z",
};

const creator = new Vue({
    el: '#vehicleInventory',
    data: {
        resourceName: "fpd_vehicleInventory",
        isOpened: false,
        wheel: false,
    },
    methods: {
        CreateInventory(){
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
            this.wheel.createWheel(['imgsrc:cone.png', 'imgsrc:ammo.png', 'imgsrc:barrier.png' ]);
            this.wheel.navItems[0].selected = false;
            this.wheel.navItems[1].selected = false;
            this.wheel.navItems[2].selected = false;
            this.wheel.navItems[0].navSlice.mousedown(function() {
                axios.post(`https://fpd_vehicleInventory/cone`,{type:"cone"}).then((response)=>{}).catch((error)=>{console.log(error)});
            })
            this.wheel.navItems[1].navSlice.mousedown(function() {
                axios.post(`https://fpd_vehicleInventory/ammo`,{types:"ammo"}).then((response)=>{}).catch((error)=>{console.log(error)});
            })
            this.wheel.navItems[2].navSlice.mousedown(function() {
                axios.post(`https://fpd_vehicleInventory/barrier`,{type:"barrier"}).then((response)=>{}).catch((error)=>{console.log(error)});
            })
            this.wheel.refreshWheel();

            var wheelspreader = document.getElementById("wheelnav-interaction-spreader");
            var wheelspreadertitle = document.getElementById("wheelnav-interaction-spreadertitle");
            wheelspreader.onmouseup = function() {axios.post(`https://fpd_vehicleInventory/none`,{type:"none"}).then((response)=>{}).catch((error)=>{console.log(error)});}
            wheelspreadertitle.onmouseup = function() {axios.post(`https://fpd_vehicleInventory/none`,{type:"none"}).then((response)=>{}).catch((error)=>{console.log(error)});}
        },
        destroyInventory() {
            this.isOpened = false
            this.wheel.removeWheel();
        },

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "newInstance") {
                creator.CreateInventory()
            }
            if (event.data.type == "destroyInstance") {
                creator.destroyInventory()
            }
        });
    }
}