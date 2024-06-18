async function setViewsCount() {
    const views = document.getElementById('views');
    try {
        const getUrl = 'https://api.avivilloz.com/views-count';
        const response = await fetch(getUrl);
        const data = await response.json();
        views.textContent = data.value;
    } catch (error) {
        console.error('Error:', error);
        views.textContent = '?';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    setViewsCount();
});
