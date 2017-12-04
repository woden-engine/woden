initialization
initialize
	super initialize.
	vertices := SLVMNativeOrderedCollection for: WTGenericVertexF.
	indices := SLVMNativeOrderedCollection for: #int.
	submeshes := OrderedCollection new.
	baseVertex := 0.
	currentColor := Color white asWMVector4F.