const armory = new Vue({
    el: '#armory',
    data: {
        ResourceName: "em_pd_armory",
        showArmory: false,
        armoryData: false,
        showInfo: false,
        buying: false,
        showError: false,
    },
    methods: {
        render(data) {
            this.showArmory = true
            this.armoryData = data
        },
        exitArmory() {
            this.showArmory = false;
            this.armoryData = false;
            this.showInfo = false;
            this.buying = false;
            this.showError = false
            axios.post(`https://em_pd_armory/exitArmory`, {}).then((response) =>{}).catch((error)=>{console.log(error)});
        },
        buyWeapon(hash) {
            if (!this.buying) {
                this.showError = false;
                this.showInfo = false;
                axios.post(`https://em_pd_armory/checkout`,{cartHash:hash}).then((response) =>{}).catch((error)=>{console.log(error)});
                this.buying = true;
            }
        },
        error() {
            this.showError = true;
        },
        success() {
            this.showInfo = true;
            this.buying = false;
        }
    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "showArmory") {
                armory.render(event.data.data);
            }
            if (event.data.type == "showError") {
                armory.error()
            }
            if (event.data.type == "showSuccess") {
                armory.success()
            }
        });
    }
}