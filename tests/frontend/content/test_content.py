def test_content(sb, website_url):
    sb.open(website_url)
    sb.assert_title("Cloud Resume")
    sb.assert_element(".category-title")
