import pytest


@pytest.fixture(scope="session")
def views_count_api_endpoint(pytestconfig) -> str:
    api_endpoint = pytestconfig.getoption("api_endpoint")
    return f"{api_endpoint}/views-count"
