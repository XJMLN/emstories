const dispatch = new Vue({
    el: '#dispatch',
    data: {
        ResourceName: "em_dispatch",
        showDispatch: false,
        dispatchTitle: '',
        dispatchLocation: '',
    },
    methods: {
        render(data) {
            this.showDispatch = true;
            this.dispatchTitle = data.title;
            this.dispatchLocation = data.textLocation;
            this.dispatchCode = data.code;
            dispatch.playSound("sounds/code"+data.code+".ogg");
        },
        playSound(soundFile) {
            var audios = new Audio(soundFile);
            audios.volume = 0.1
            audios.play();
        },
        exit(data) {
            if (data.music) {
                dispatch.playSound("sounds/respond"+data.music+".ogg");
            }
            this.showDispatch =false;
            this.dispatchTitle ='';
            this.dispatchLocation='';
        }
    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "drawDispatch") {
                dispatch.render(event.data.data);
            }
            if (event.data.type == "cancelDispatch") {
                dispatch.exit(event.data);
            }
        });
    }
}