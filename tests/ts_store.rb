require_relative "../Store"
require "test/unit"
 
class TestStore < Test::Unit::TestCase
  @@definiton = "myModule.combos.MyCombo"
  $config = {}
  $config["project_name"] = "MyProject"
  
  def test_store_definition
    assert_equal("#{$config["project_name"]}.store.myModule.combos.MyCombo",
                 Store.new(@@definiton, ["-s"]).get_definition())
  end

end
