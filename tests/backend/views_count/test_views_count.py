import requests


def test_views_count(views_count_api_endpoint: str):
    """
    Testing POST and GET methods for views-count API endpoint
    """
    test_value = 0
    response = requests.post(views_count_api_endpoint, json={"value": test_value})
    assert response.status_code == 200

    response_json = response.json()
    assert "value" in response_json
    assert response_json.get("value") == test_value

    response = requests.get(views_count_api_endpoint)
    assert response.status_code == 200

    response_json = response.json()
    assert "value" in response_json
    assert response_json.get("value") == (test_value + 1)
