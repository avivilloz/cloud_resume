async function setViewsCount() {
    const views = document.getElementById('views');
    try {
        const getUrl = "__API_URL__/views-count";
        const response = await fetch(getUrl);
        const data = await response.json();
        views.textContent = data.value.toString();
    } catch (error) {
        console.error('Error:', error);
        views.textContent = '?';
    }
}

document.addEventListener('DOMContentLoaded', function () {
    setViewsCount();
});
