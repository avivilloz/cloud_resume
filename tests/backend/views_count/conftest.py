import pytest


def pytest_addoption(parser):
    parser.addoption("--api-endpoint", action="store", default="")


@pytest.fixture(scope="session")
def views_count_api_endpoint(pytestconfig) -> str:
    return f"{pytestconfig.getoption("api_endpoint")}/views-count"
