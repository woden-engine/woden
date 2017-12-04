building
addElement: elementName type: elementType count: bindingPointCount
	elements add: (WDCShaderSignatureSpecDescriptor new
			name: elementName;
			index: totalBindingPointCount;
			type: elementType;
			count: bindingPointCount;
			yourself).
	totalBindingPointCount := totalBindingPointCount + bindingPointCount