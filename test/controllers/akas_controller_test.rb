require 'test_helper'

class AkasControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "we can find song-ids" do
  	get :index
  	assert_select "[data-song-id]"
  end
end
