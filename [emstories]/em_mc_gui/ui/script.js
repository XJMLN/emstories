 var icon = {
    cross: "M24.778,21.419 19.276,15.917 24.777,10.415 21.949,7.585 16.447,13.087 10.945,7.585 8.117,10.415 13.618,15.917 8.116,21.419 10.946,24.248 16.447,18.746 21.948,24.248z",
};

const emsInteraction = new Vue({
    el: '#emsInteraction',
    data: {
        resourceName: "em_mc_gui",
        isOpened: false,
        wheel: false,
        showPedData: false,
        pedData: false,
        stretcher: false,
        description: "",
    },
    methods: {
        CreateInteraction(bag,stretcher){
            this.isOpened = true;
            this.stretcher = stretcher;
            this.bag = bag;
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
            if (this.pedData.temp >0) {
                this.pedData.temp = this.pedData.temp.toFixed(2);
            }
            this.wheel.spreaderOutTitle = icon.cross;
            var images = ["imgsrc:actions/testy.png","imgsrc:actions/bag.png"];
            if (this.stretcher) {
                images.push("imgsrc:actions/nosze.png");
            }
            this.wheel.createWheel(images);
            this.wheel.navItems[0].selected = false
            this.wheel.navItems[0].navSlice.mouseover(function(){
                emsInteraction.description = "Wykonaj testy"
            })
            this.wheel.navItems[0].navSlice.mouseout(function(){
                emsInteraction.description = ""
            })
            this.wheel.navItems[0].navSlice.mousedown(function(){
                if (emsInteraction.bag) {
                    emsInteraction.showCategory(0)
                }
            })
            this.wheel.navItems[1].selected = false
            this.wheel.navItems[1].navSlice.mouseover(function(){
                emsInteraction.description = "Torba medyczna"
            })
            this.wheel.navItems[1].navSlice.mouseout(function(){
                emsInteraction.description = ""
            })
            this.wheel.navItems[1].navSlice.mousedown(function(){
                if (emsInteraction.bag) {
                    emsInteraction.showCategory(1)
                }
            })
            if (this.wheel.navItems[2]) {
                this.wheel.navItems[2].selected = false
                this.wheel.navItems[2].navSlice.mouseover(function(){
                    emsInteraction.description = "Przenieś osobę na nosze"
                })
                this.wheel.navItems[2].navSlice.mouseout(function(){
                    emsInteraction.description = ""
                })
                this.wheel.navItems[2].navSlice.mousedown(function(){
                    axios.post(`https://em_mc_gui/Interaction`,{actionID:6}).then((response)=>{
                    }).catch((error)=>{console.log(error)});
                })
            }
            this.wheel.refreshWheel();
            var wheelspreader = document.getElementById("wheelnav-interaction-spreader");
            var wheelspreadertitle = document.getElementById("wheelnav-interaction-spreadertitle");
            wheelspreader.onmouseup = function() {axios.post(`https://em_mc_gui/Interaction`,{actionID:-1}).then((response)=>{}).catch((error)=>{console.log(error)});}
            wheelspreadertitle.onmouseup = function() {axios.post(`https://em_mc_gui/Interaction`,{actionID:-1}).then((response)=>{}).catch((error)=>{console.log(error)});}
        },
        showCategory(CID) {
            this.description = ""
            this.wheel.removeWheel();
            this.wheel = false
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
            var images2 = false
            if (CID === 0) {
                images2 = ["imgsrc:actions/temp.png","imgsrc:actions/cardio.png","imgsrc:actions/look.png"]
            }
            if (CID == 1) {
                images2 = ["imgsrc:actions/pills.png","imgsrc:actions/stability.png"]
            }
            this.wheel.createWheel(images2);
            this.wheel.navItems[0].selected = false
            this.wheel.navItems[1].selected = false
            if (this.wheel.navItems[2]) {
                this.wheel.navItems[2].selected = false
            }
            if (CID === 0) {
                this.wheel.navItems[0].navSlice.mouseover(function(){
                    emsInteraction.description = "Zmierz temperaturę"
                })
                this.wheel.navItems[0].navSlice.mouseout(function(){
                    emsInteraction.description = ""
                })
                this.wheel.navItems[0].navSlice.mousedown(function(){
                    axios.post(`https://em_mc_gui/Interaction`,{actionID:1}).then((response)=>{}).catch((error)=>{console.log(error)});
                })
                this.wheel.navItems[1].navSlice.mouseover(function(){
                    emsInteraction.description = "Zmierz puls"
                })
                this.wheel.navItems[1].navSlice.mouseout(function(){
                    emsInteraction.description = ""
                })
                this.wheel.navItems[1].navSlice.mousedown(function(){
                    axios.post(`https://em_mc_gui/Interaction`,{actionID:2}).then((response)=>{}).catch((error)=>{console.log(error)});
                })
                this.wheel.navItems[2].navSlice.mouseover(function(){
                    emsInteraction.description = "Przyjrzyj się poszkodowanemu"
                })
                this.wheel.navItems[2].navSlice.mouseout(function(){
                    emsInteraction.description = ""
                })
                this.wheel.navItems[2].navSlice.mousedown(function(){
                    axios.post(`https://em_mc_gui/Interaction`,{actionID:3}).then((response)=>{}).catch((error)=>{console.log(error)});
                })
            }
            if (CID == 1) {
                this.wheel.navItems[0].navSlice.mouseover(function(){
                    emsInteraction.description = "Podaj środki przeciwbólowe"
                })
                this.wheel.navItems[0].navSlice.mouseout(function(){
                    emsInteraction.description = ""
                })
                this.wheel.navItems[0].navSlice.mousedown(function(){
                    axios.post(`https://em_mc_gui/Interaction`,{actionID:4}).then((response)=>{}).catch((error)=>{console.log(error)});
                })
                this.wheel.navItems[1].navSlice.mouseover(function(){
                    emsInteraction.description = "Ustabilizuj złamane kończyny"
                })
                this.wheel.navItems[1].navSlice.mouseout(function(){
                    emsInteraction.description = ""
                })
                this.wheel.navItems[1].navSlice.mousedown(function(){
                    axios.post(`https://em_mc_gui/Interaction`,{actionID:5}).then((response)=>{}).catch((error)=>{console.log(error)});
                })
            }
            this.wheel.refreshWheel();
            var wheelspreader = document.getElementById("wheelnav-interaction-spreader");
            var wheelspreadertitle = document.getElementById("wheelnav-interaction-spreadertitle");
            wheelspreader.onmouseup = function() {axios.post(`https://em_mc_gui/Interaction`,{actionID:-1}).then((response)=>{}).catch((error)=>{console.log(error)});}
            wheelspreadertitle.onmouseup = function() {axios.post(`https://em_mc_gui/Interaction`,{actionID:-1}).then((response)=>{}).catch((error)=>{console.log(error)});}
        },
        showInformations(data){
            this.pedData = data;
            this.showPedData = true
            if (this.pedData.temp) {
                this.pedData.temp = this.pedData.temp.toFixed(1);
            }
        },
        updateInformations(data) {
            this.pedData = data
            if (this.pedData.temp) {
                this.pedData.temp = this.pedData.temp.toFixed(1);
            }
        },
        destroyInteraction(all) {
            this.isOpened = false
            this.description = ""
            this.wheel.removeWheel();
            this.pedData = false
            this.showPedData = false
        },

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "openInteraction") {
                emsInteraction.CreateInteraction(event.data.data.hasBag,event.data.data.hasStretcher)
            }
            if (event.data.type == "showPedInformation"){
                emsInteraction.showInformations(event.data.data)
            }
            if (event.data.type == "updatePedData") {
                emsInteraction.updateInformations(event.data.data)
            }
            if (event.data.type == "closeInteraction") {
                emsInteraction.destroyInteraction(event.data.data)
            }
        });
    }
}