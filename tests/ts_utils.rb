require_relative "../Utils"
require "test/unit"

class TestUtils < Test::Unit::TestCase
  @@path = "module.awesomeCombos.MyCombo"

  def test_definition_to_file
    assert_equal("view/module/awesomeCombos/MyCombo.js", Utils.new().path_to_file(@@path, "view"))
  end

  def test_definition_to_alias
    assert_equal("moduleAwesomeCombosMyCombo", Utils.new().path_to_alias(@@path))
  end

  def test_export_js_notation
    assert_equal({:person => {:name => 'testName'}}, Utils.new().export_js_notation("person.name:'testName'"))
  end
  
  def test_eval_values
    assert_equal("test", "test".eval_value)
    assert_equal(1, "1".eval_value)
    assert_equal(false, "false".eval_value)
  end

  def test_parse_js_notation
    result = {
      :person => {
        :name => 'testName',
        :age => 32
      },
      :border => false
    }
    assert_equal(result, Utils.new().parse_js_notation(["person.name:'testName'",
                                                         "person.age:32",
                                                         "border:false"]))
  end
  
end
