
async function setViewersCount() {
    const viewers = document.getElementById('viewers');

    try {
        const getUrl = 'https://api.avivilloz.com/total-viewers';

        const response = await fetch(getUrl);
        if (!response.ok) {
            throw new Error(`Get request failed with status: ${response.status}`);
        }

        const data = await response.json();
        viewers.textContent = data.body.value;
    } catch (error) {
        console.error('Error:', error);
        viewers.textContent = '?';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    setViewersCount();
});
