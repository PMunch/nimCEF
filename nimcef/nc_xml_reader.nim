import cef_types, nc_util, nc_stream

# Structure that supports the reading of XML data via the libxml streaming API.
# The functions of this structure should only be called on the thread that
# creates the object.
wrapAPI(NCXmlReader, cef_xml_reader)

# Moves the cursor to the next node in the document. This function must be
# called at least once to set the current cursor position. Returns true (1)
# if the cursor position was set successfully.
proc moveToNextNode*(self: NCXmlReader): bool =
  self.wrapCall(move_to_next_node, result)

# Close the document. This should be called directly to ensure that cleanup
# occurs on the correct thread.
proc close*(self: NCXmlReader): int =
  self.wrapCall(close, result)

# Returns true (1) if an error has been reported by the XML parser.
proc hasError*(self: NCXmlReader): bool =
  self.wrapCall(has_error, result)

# Returns the error string.
proc getError*(self: NCXmlReader): string =
  self.wrapCall(get_error, result)

# The below functions retrieve data for the node at the current cursor
# position.
# Returns the node type.
proc getType*(self: NCXmlReader): cef_xml_node_type =
  self.wrapCall(get_type, result)

# Returns the node depth. Depth starts at 0 for the root node.
proc getDepth*(self: NCXmlReader): int =
  self.wrapCall(get_depth, result)

# Returns the local name. See http:#www.w3.org/TR/REC-xml-names/#NT-
# LocalPart for additional details.
proc getLocalName*(self: NCXmlReader): string =
  self.wrapCall(get_local_name, result)

# Returns the namespace prefix. See http:#www.w3.org/TR/REC-xml-names/ for
# additional details.
proc getPrefix*(self: NCXmlReader): string =
  self.wrapCall(get_prefix, result)

# Returns the qualified name, equal to (Prefix:)LocalName. See
# http:#www.w3.org/TR/REC-xml-names/#ns-qualnames for additional details.
proc getQualifiedName*(self: NCXmlReader): string =
  self.wrapCall(get_qualified_name, result)

# Returns the URI defining the namespace associated with the node. See
# http:#www.w3.org/TR/REC-xml-names/ for additional details.
proc getNamespaceUri*(self: NCXmlReader): string =
  self.wrapCall(get_namespace_uri, result)

# Returns the base URI of the node. See http:#www.w3.org/TR/xmlbase/ for
# additional details.
proc getBaseUri*(self: NCXmlReader): string =
  self.wrapCall(get_base_uri, result)

# Returns the xml:lang scope within which the node resides. See
# http:#www.w3.org/TR/REC-xml/#sec-lang-tag for additional details.
proc getXmlLang*(self: NCXmlReader): string =
  self.wrapCall(get_xml_lang, result)

# Returns true (1) if the node represents an NULL element. <a/> is considered
# NULL but <a></a> is not.
proc isEmptyElement*(self: NCXmlReader): bool =
  self.wrapCall(is_empty_element, result)

# Returns true (1) if the node has a text value.
proc hasValue*(self: NCXmlReader): bool =
  self.wrapCall(has_value, result)

# Returns the text value.
proc getValue*(self: NCXmlReader): string =
  self.wrapCall(get_value, result)

# Returns true (1) if the node has attributes.
proc hasAttributes*(self: NCXmlReader): bool =
  self.wrapCall(has_attributes, result)

# Returns the number of attributes.
proc getAttributeCount*(self: NCXmlReader): int =
  self.wrapCall(get_attribute_count, result)

# Returns the value of the attribute at the specified 0-based index.
proc getAttributeByIndex*(self: NCXmlReader, index: int): string =
  self.wrapCall(get_attribute_byindex, result, index)

# Returns the value of the attribute with the specified qualified name.
proc getAttributeByQname*(self: NCXmlReader, qualifiedName: string): string =
  self.wrapCall(get_attribute_byqname, result, qualifiedName)

# Returns the value of the attribute with the specified local name and
# namespace URI.
proc getAttributeByLname*(self: NCXmlReader, localName, namespaceURI: string): string =
  self.wrapCall(get_attribute_bylname, result, localName, namespaceURI)

# Returns an XML representation of the current node's children.
proc getInnerXml*(self: NCXmlReader): string =
  self.wrapCall(get_inner_xml, result)

# Returns an XML representation of the current node including its children.
proc getOuterXml*(self: NCXmlReader): string =
  self.wrapCall(get_outer_xml, result)

# Returns the line number for the current node.
proc getLineNumber*(self: NCXmlReader): int =
  self.wrapCall(get_line_number, result)

# Attribute nodes are not traversed by default. The below functions can be
# used to move the cursor to an attribute node. move_to_carrying_element()
# can be called afterwards to return the cursor to the carrying element. The
# depth of an attribute node will be 1 + the depth of the carrying element.
# Moves the cursor to the attribute at the specified 0-based index. Returns
# true (1) if the cursor position was set successfully.
proc moveToAttributeByIndex*(self: NCXmlReader, index: int): bool =
  self.wrapCall(move_to_attribute_byindex, result, index)

# Moves the cursor to the attribute with the specified qualified name.
# Returns true (1) if the cursor position was set successfully.
proc moveToAttributeByQname*(self: NCXmlReader, qualifiedName: string): bool =
  self.wrapCall(move_to_attribute_byqname, result, qualifiedName)

# Moves the cursor to the attribute with the specified local name and
# namespace URI. Returns true (1) if the cursor position was set
# successfully.
proc moveToAttributeByLname*(self: NCXmlReader, localName, namespaceURI: string): bool =
  self.wrapCall(move_to_attribute_bylname, result, localName, namespaceURI)

# Moves the cursor to the first attribute in the current element. Returns
# true (1) if the cursor position was set successfully.
proc moveToFirstAttribute*(self: NCXmlReader): bool =
  self.wrapCall(move_to_first_attribute, result)

# Moves the cursor to the next attribute in the current element. Returns true
# (1) if the cursor position was set successfully.
proc moveToNextAttribute*(self: NCXmlReader): bool =
  self.wrapCall(move_to_next_attribute, result)

# Moves the cursor back to the carrying element. Returns true (1) if the
# cursor position was set successfully.
proc moveToCarryingElement*(self: NCXmlReader): bool =
  self.wrapCall(move_to_carrying_element, result)

# Create a new NCXmlReader object. The returned object's functions can
# only be called from the thread that created the object.
proc ncXmlReaderCreate*(stream: NCStreamReader, encodingType: cef_xml_encoding_type, URI: string): NCXmlReader =
  wrapProc(cef_xml_reader_create, result, stream, encodingType, URI)

