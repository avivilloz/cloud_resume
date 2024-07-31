import pytest


@pytest.fixture(scope="session")
def views_count_api_url(api_url: str) -> str:
    return f"{api_url}/views-count"
