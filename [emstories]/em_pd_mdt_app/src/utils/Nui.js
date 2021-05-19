export default {
    async send(event, data = {}) {
        /* eslint-disable no-unreachable */
        return await fetch(`https://em_pd_mdt/${event}`, {
            method: 'post',
            headers: {
                'Content-type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(data),
        });
        /* eslint-enable no-unreachable  */
    },
};