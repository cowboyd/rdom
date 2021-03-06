require File.expand_path('../../test_helper', __FILE__)

class AttrTest < Test::Unit::TestCase
  attr_reader :window, :document, :div, :attr

  def setup
    @window = RDom::Window.new('<html><body><div id="foo"></div></body></html>')
    window.evaluate <<-js
      var div  = document.getElementById('foo')
      var attr = div.getAttributeNode('id')
    js
    @document = window.document
    @div  = window.evaluate("div")
    @attr = window.evaluate("attr")
  end

  test "ruby: ownerElement gets the element to which the attribute belongs", :ruby, :dom_1_core do
    assert_equal div, attr.ownerElement
  end

  test "js: ownerElement gets the element to which the attribute belongs", :js, :dom_1_core do
    assert_equal div, window.evaluate("attr.ownerElement")
  end

  test "ruby: specified is true if the attribute was given a value in the original document", :ruby, :dom_1_core do
    assert attr.specified
  end

  # TODO
  # test "ruby: specified is false if the attribute was not given a value in the original document (setAttribute)", :ruby, :dom_1_core do
  #   div.setAttribute('id', 'bar')
  #   assert !attr.specified
  # end
  # 
  # test "ruby: specified is false if the attribute was not given a value in the original document (attributes)", :ruby, :dom_1_core do
  #   div.attributes['id'].value = 'bar'
  #   assert !div.getAttributeNode('id').specified
  # end
  # 
  # test "ruby: specified is false if the attribute was not given a value in the original document (setAttributeNode)", :ruby, :dom_1_core do
  #   attribute = document.createAttribute('id')
  #   attribute.value = 'bar'
  #   div.setAttributeNode(attribute)
  #   assert !div.getAttributeNode('id').specified
  # end

  test "ruby: parentNode is null for Attr objects", :ruby, :dom_1_core do
    assert_nil attr.parentNode
  end

  test "ruby: previousSibling is null for Attr objects", :ruby, :dom_1_core do
    assert_nil attr.previousSibling
  end

  test "ruby: nextSibling is null for Attr objects", :ruby, :dom_1_core do
    assert_nil attr.nextSibling
  end

  test 'ruby: reading checked (using getAttribute) returns true if the attribute is checked="checked"' do
    window.load('<html><body><input type="radio" checked="checked" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    assert_equal true, input.getAttribute('checked')
  end

  test 'ruby: reading checked (using .checked) returns true if the attribute is checked="checked"' do
    window.load('<html><body><input type="radio" checked="checked" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    assert_equal true, input.checked
  end

  test 'ruby: reading checked (using getAttribute) returns false if the attribute is checked=""' do
    window.load('<html><body><input type="radio" checked="" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    assert_equal false, input.getAttribute('checked')
  end

  test 'ruby: reading checked (using .checked) returns false if the attribute is checked=""' do
    window.load('<html><body><input type="radio" checked="" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    assert_equal false, input.checked
  end

  test 'ruby: reading checked (using getAttribute) returns nil if the attribute is not present' do
    window.load('<html><body><input type="radio" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    assert_equal nil, input.getAttribute('checked')
  end

  test 'ruby: reading checked (using .checked) returns false if the attribute is not present' do
    window.load('<html><body><input type="radio" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    assert_equal false, input.checked
  end

  test 'ruby: setting checked to true (using setAttribute) results in an attribute checked' do
    window.load('<html><body><input type="radio" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    input.setAttribute('checked', true)
    assert_equal '<input type="radio" checked>', input.to_s
  end

  test 'ruby: setting checked to true (using checked=) results in an attribute checked' do
    window.load('<html><body><input type="radio" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    input.checked = true
    assert_equal '<input type="radio" checked>', input.to_s
  end

  test 'ruby: setting checked to false (using setAttribute) results in an attribute checked' do
    window.load('<html><body><input type="radio" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    input.setAttribute('checked', false)
    assert_equal '<input type="radio" checked>', input.to_s
  end

  test 'ruby: setting checked to false (using checked=) removes the attribute checked' do
    window.load('<html><body><input type="radio" /></body></html>')
    input = window.document.getElementsByTagName('input').first
    input.checked = false
    assert_equal '<input type="radio">', input.to_s
  end
end