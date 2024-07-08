import pytest


def pytest_addoption(parser):
    parser.addoption("--api-url", action="store", default="")


@pytest.fixture(scope="session")
def api_url(pytestconfig) -> str:
    return pytestconfig.getoption("api_url")
