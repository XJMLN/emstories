const notification = new Vue({
    el: '#notification',
    data: {
        ResourceName: "em_gui",
        showNotify: false,
        msg: '',
        title: '',
        sound:false,
        volume:0.1,
    },
    methods: {
        render(data) {
            this.showNotify = data.display
            if (this.showNotify) {
                if (data.sound) {
                    notification.playSound("sounds/notification.ogg")
                }
                this.title = data.title
                this.msg = data.message
            }
        },
        playSound(soundFile) {
            var audios = new Audio(soundFile);
            audios.volume = 0.1
            audios.play();
        },
    },
})

document.onreadystatechange = () => {
    if (document.readyState == "complete") {
        window.addEventListener("message", (event) => {
            if (event.data.type == "message") {
                notification.render(event.data.data);
            }
        });
    }
}