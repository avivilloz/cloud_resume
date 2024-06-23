import requests

VIEWS_COUNT_API_ENDPOINT = "https://api.avivilloz.com/views-count"


def test_views_count():
    """
    Testing POST and GET methods for views-count API endpoint
    """
    test_value = 0
    response = requests.post(VIEWS_COUNT_API_ENDPOINT, json={"value": test_value})
    assert response.status_code == 200

    response_json = response.json()
    assert "value" in response_json
    assert response_json.get("value") == test_value

    response = requests.get(VIEWS_COUNT_API_ENDPOINT)
    assert response.status_code == 200

    response_json = response.json()
    assert "value" in response_json
    assert response_json.get("value") == (test_value + 1)
