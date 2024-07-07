def pytest_addoption(parser):
    parser.addoption("--api-endpoint", action="store", default="")
