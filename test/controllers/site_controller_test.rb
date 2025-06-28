require "test_helper"

class SiteControllerTest < ActionDispatch::IntegrationTest
  test "should get toc" do
    get site_toc_url
    assert_response :success
  end

  test "should get provider_toc" do
    get site_provider_toc_url
    assert_response :success
  end
end
