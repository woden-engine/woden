initialization
initialize
	super initialize.
	vertices := NativeOrderedCollection for: self vertexType.
	indices := NativeOrderedCollection for: #int.
	