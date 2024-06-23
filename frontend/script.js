async function setViewsCount() {
    const views = document.getElementById('views');
    try {
        const getUrl = "__VIEWS_COUNT_API_ENDPOINT__";
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
