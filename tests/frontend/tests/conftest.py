import pytest


def pytest_addoption(parser):
    parser.addoption("--website-url", action="store", default="")


@pytest.fixture(scope="session")
def website_url(pytestconfig) -> str:
    return pytestconfig.getoption("website_url")
