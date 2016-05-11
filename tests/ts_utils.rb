require_relative "../Utils"
require "test/unit"
 
class TestUtils < Test::Unit::TestCase
  @@path = "module.awesomeCombos.MyCombo"
   
  def test_definition_to_file
    assert_equal("view/module/awesomeCombos/MyCombo.js", Utils.new().path_to_file(@@path, "view"))
  end
end
