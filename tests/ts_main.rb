require_relative "main"
require "test/unit"
 
class TestUtils < Test::Unit::TestCase
  @@path = "module.combos.MyCombo"
 
  def test_path_to_alias
    assert_equal("moduleCombosMyCombo", Utils.new().path_to_alias(@@path))
  end

  def test_path_to_file
    assert_equal("view/module/combos/MyCombo.js", Utils.new().path_to_file(@@path, "view"))
  end

end
