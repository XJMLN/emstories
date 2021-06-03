const dmv = new Vue({
    el: '#dmv',
    data: {
        ResourceName: "em_dmv",
        showDMV: false,
        showsError: false,
        errorMsg: ''
    },
    methods: {
        render(data) {
            this.showDMV = true
        },
        closeDMV() {
            this.showDMV = false;
            this.showsError = false;
            axios.post(`https://em_dmv/exitDMV`, {a:true}).then((response) =>{}).catch((error)=>{console.log(error)});
        },
        startExam(ID) {
            this.showDMV = false;
            this.showsError = false;
            axios.post(`https://em_dmv/examCheckout`, {exam:ID}).then((response) =>{}).catch((error)=>{console.log(error)});
        },
        showingError(text) {
            this.showsError = true
            this.errorMsg = text
            this.showDMV = true
        }

    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "showDMV") {
                dmv.render(event.data.data);
            }
            if (event.data.type == "showError") {
                dmv.showingError(event.data.data);
            }
            if (event.data.type == "closeDMV") {
                dmv.closeDMV();
            }
        });
    }
}