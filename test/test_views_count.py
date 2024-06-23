import requests

VIEWS_COUNT_API_ENDPOINT = "https://api.avivilloz.com/views-count"

def test_get_views_count():
    """
    """
    response = requests.get(VIEWS_COUNT_API_ENDPOINT)
    assert response.status_code == 200

    response_json = response.json()
    assert "value" in response_json

    response = requests.post(VIEWS_COUNT_API_ENDPOINT, data={"value": 125})
    print(response.json())
    assert response.status_code == 200

    response_json = response.json()
    assert "value" in response_json

    print(response_json)
