initialization
initialize
	super initialize.
	vertices := NativeOrderedCollection for: WTGenericVertexF.
	indices := NativeOrderedCollection for: #int.
	submeshes := OrderedCollection new.
	baseVertex := 0.
	currentColor := Color white asWMVector4F.