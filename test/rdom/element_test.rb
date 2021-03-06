require File.expand_path('../../test_helper', __FILE__)

class ElementTest < Test::Unit::TestCase
  attr_reader :window, :document, :body, :div
  
  def setup
    @window = RDom::Window.new('<html><body><div id="foo">FOO</div></body></html>')
    @document = window.document
    @body = document.getElementsByTagName('//body').first
    @div = document.getElementsByTagName('//div').first
    window.evaluate <<-js
      var body = document.body;
      var div  = document.getElementsByTagName('div')[0];
    js
  end
  
  test "ruby: innerHTML", :ruby, :dom_0 do
    assert_equal '<div id="foo">FOO</div>', document.body.innerHTML
    assert_equal 'FOO', div.innerHTML
  end
  
  test "js: innerHTML", :js, :dom_0 do
    assert_equal '<div id="foo">FOO</div>', window.evaluate("body.innerHTML")
    assert_equal 'FOO', window.evaluate("div.innerHTML")
  end
  
  test "ruby: innerHTML= (1)", :ruby, :dom_0 do
    div.innerHTML = '<span>bar</span><span>baz</span>'
    assert_equal "<div id=\"foo\">\n<span>bar</span><span>baz</span>\n</div>", body.innerHTML
  end

  test "ruby: innerHTML= (2)", :ruby, :dom_0 do
    div = document.getElementsByTagName('//div').first
    div.innerHTML = '<div><span>hi</span> there</div>'
    assert_equal "<div>\n<span>hi</span> there</div>", div.innerHTML
  end
  
  test "js: innerHTML=", :js, :dom_0 do
    window.evaluate("div.innerHTML = '<span>bar</span><span>baz</span>'")
    assert_equal "<div id=\"foo\">\n<span>bar</span><span>baz</span>\n</div>", window.evaluate("body.innerHTML")
  end
  
  # DOM-Level-1-Core
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html#ID-745549614
  test "ruby: tagName The name of the tag for the given element", :ruby, :dom_1_core do
    assert_equal 'DIV', div.nodeName
  end

  test "js: tagName The name of the tag for the given element", :js, :dom_1_core do
    assert_equal 'DIV', window.evaluate("div.nodeName")
  end

  test "ruby: getAttribute(name) retrieves the value of the named attribute from the current node", :ruby, :dom_1_core do
    assert_equal 'foo', div.getAttribute('id')
  end

  test "js: getAttribute(name) retrieves the value of the named attribute from the current node", :js, :dom_1_core do
    assert_equal 'foo', window.evaluate("div.getAttribute('id')")
  end

  test "ruby: getAttributeNode(name) retrieves the node representation of the named attribute from the current node", :ruby, :dom_1_core do
    assert_equal 'foo', div.getAttributeNode('id').value
  end

  test "js: getAttributeNode(name) retrieves the node representation of the named attribute from the current node", :js, :dom_1_core do
    assert_equal 'foo', window.evaluate("div.getAttributeNode('id').value")
  end

  test "ruby: setAttribute(name, value) sets the value of the named attribute from the current node", :ruby, :dom_1_core do
    div.setAttribute('title', 'bar')
    assert_equal 'bar', div.getAttribute('title')
  end

  test "js: setAttribute(name, value) sets the value of the named attribute from the current node", :js, :dom_1_core do
    div.setAttribute('title', 'bar')
    assert_equal 'bar', window.evaluate("div.getAttribute('title')")
  end

  test "ruby: setAttributeNode(name, attrNode) sets the node representation of the named attribute from the current node", :ruby, :dom_1_core do
    attribute = document.createAttribute('boz')
    attribute.value = 'buz'
    div.setAttributeNode(attribute)
    assert_equal 'buz', div.getAttribute('boz')
  end

  test "js: setAttributeNode(name, attrNode) sets the node representation of the named attribute from the current node", :js, :dom_1_core do
    window.evaluate <<-js
      attribute = document.createAttribute('boz')
      attribute.value = 'buz'
      div.setAttributeNode(attribute)
    js
    assert_equal 'buz', window.evaluate("div.getAttribute('boz')")
  end

  test "ruby: removeAttribute(name) removes the named attribute from the current node", :ruby, :dom_1_core do
    window.evaluate("div.removeAttribute('id')")
    assert_equal '<div>FOO</div>', window.evaluate("div").to_s
  end

  test "js: removeAttribute(name) removes the named attribute from the current node", :js, :dom_1_core do
    window.evaluate("div.removeAttribute('id')")
    assert_equal '<div>FOO</div>', window.evaluate("div").to_s
  end

  test "ruby: removeAttributeNode(attrNode) removes the node representation of the named attribute from the current node", :ruby, :dom_1_core do
    div.removeAttributeNode('id')
    assert_equal '<div>FOO</div>', div.to_s
  end

  test "js: removeAttributeNode(attrNode) removes the node representation of the named attribute from the current node", :js, :dom_1_core do
    window.evaluate("div.removeAttribute('id')")
    assert_equal '<div>FOO</div>', window.evaluate("div").to_s
  end

  test "ruby: getElementsByTagName(name) retrieves a set of all descendant elements, of a particular tag name, from the current element", :ruby, :dom_1_core do
    elements = body.getElementsByTagName('div')
    assert_equal 1, elements.size
    assert_equal 'DIV', elements.first.nodeName
  end

  test "js: getElementsByTagName(name) retrieves a set of all descendant elements, of a particular tag name, from the current element", :js, :dom_1_core do
    window.evaluate("elements = body.getElementsByTagName('div')")
    assert_equal 1, window.evaluate("elements.length")
    assert_equal 'DIV', window.evaluate("elements[0].nodeName")
  end

  # DOM-Level-1-Html
  # http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-html.html
  
  # All HTML element interfaces derive from this class. Elements that only expose 
  # the HTML core attributes are represented by the base HTMLElement interface. 
  # These elements are as follows:
  # HEAD, SUB, SUP, SPAN, BDO, TT, I, B, U, S, STRIKE, BIG, SMALL, EM, STRONG, 
  # DFN, CODE, SAMP, KBD, VAR, CITE, ACRONYM, ABBR, DD, DT, NOFRAMES, NOSCRIPT
  # ADDRESS, CENTER
  
  test "ruby: id - the id of the element", :ruby, :dom_1_html do
    div.id = 'bar'
    assert_equal 'bar', div.id
    assert_equal 'bar', div.getAttribute('id')
  end

  test "js: id - the id of the element", :js, :dom_1_html do
    window.evaluate("div.id = 'bar'")
    assert_equal 'bar', window.evaluate("div.id")
    assert_equal 'bar', window.evaluate("div.getAttribute('id')")
  end

  test "ruby: title - the title attribute of the element", :ruby, :dom_1_html do
    div.title = 'bar'
    assert_equal 'bar', div.title
    assert_equal 'bar', div.getAttribute('title')
  end

  test "js: title - the title attribute of the element", :js, :dom_1_html do
    window.evaluate("div.title = 'bar'")
    assert_equal 'bar', window.evaluate("div.title")
    assert_equal 'bar', window.evaluate("div.getAttribute('title')")
  end

  test "ruby: lang - the language of an element's attributes, text, and element contents", :ruby, :dom_1_html do
    div.lang = 'bar'
    assert_equal 'bar', div.lang
    assert_equal 'bar', div.getAttribute('lang')
  end

  test "js: lang - the language of an element's attributes, text, and element contents", :js, :dom_1_html do
    window.evaluate("div.lang = 'bar'")
    assert_equal 'bar', window.evaluate("div.lang")
    assert_equal 'bar', window.evaluate("div.getAttribute('lang')")
  end

  test "ruby: dir - the directionality of the element", :ruby, :dom_1_html do
    div.dir = 'bar'
    assert_equal 'bar', div.dir
    assert_equal 'bar', div.getAttribute('dir')
  end

  test "js: dir - the directionality of the element", :js, :dom_1_html do
    window.evaluate("div.dir = 'bar'")
    assert_equal 'bar', window.evaluate("div.dir")
    assert_equal 'bar', window.evaluate("div.getAttribute('dir')")
  end

  test "ruby: className - the class of the element", :ruby, :dom_1_html do
    div.className = 'bar'
    assert_equal 'bar', div.className
    assert_equal 'bar', div.getAttribute('class')
    assert_equal '<div id="foo" class="bar">FOO</div>', div.to_s
  end

  test "js: className - the class of the element", :js, :dom_1_html do
    window.evaluate("div.className = 'bar'")
    assert_equal 'bar', window.evaluate("div.className")
    assert_equal 'bar', window.evaluate("div.getAttribute('class')")
    assert_equal '<div id="foo" class="bar">FOO</div>', window.evaluate("div").to_s
  end

  # DOM-Level-2-Core
  # http://www.w3.org/TR/2000/REC-DOM-Level-2-Core-20001113/core.html#i-Document
  # test "ruby: getAttributeNS(namespace, name) Retrieve the value of the attribute with the specified name and namespace, from the current node", :ruby, :dom_2_core do
  # end
  # 
  # test "ruby: getAttributeNodeNS(namespace, name) Retrieve the node representation of the attribute with the specified name and namespace, from the current node", :ruby, :dom_2_core do
  # end
  # 
  # test "ruby: setAttributeNS(namespace, name, value) Set the value of the attribute with the specified name and namespace, from the current node", :ruby, :dom_2_core do
  # end
  # 
  # test "ruby: setAttributeNodeNS(namespace, name, attrNode) Set the node representation of the attribute with the specified name and namespace, from the current node", :ruby, :dom_2_core do
  # end
  # 
  # test "ruby: removeAttributeNS(namespace, name) Remove the attribute with the specified name and namespace, from the current node", :ruby, :dom_2_core do
  # end

  test "ruby: hasAttribute(name) Check if the element has the specified attribute, or not", :ruby, :dom_2_core do
    assert div.hasAttribute('id')
    assert !div.hasAttribute('class')
  end

  test "js: hasAttribute(name) Check if the element has the specified attribute, or not", :js, :dom_2_core do
    assert window.evaluate("div.hasAttribute('id')")
    assert !window.evaluate("div.hasAttribute('class')")
  end

  # test "ruby: hasAttributeNS(namespace, name) Check if the element has the specified attribute, in the specified namespace, or not", :ruby, :dom_2_core do
  # end
end