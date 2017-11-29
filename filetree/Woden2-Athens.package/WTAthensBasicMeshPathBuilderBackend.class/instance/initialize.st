initialization
initialize
	super initialize.
	vertices := SLVMNativeOrderedCollection for: self vertexType.
	indices := SLVMNativeOrderedCollection for: #int.
