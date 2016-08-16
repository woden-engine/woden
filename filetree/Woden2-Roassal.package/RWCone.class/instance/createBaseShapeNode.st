hooks
createBaseShapeNode
	| node renderable |
	node := WDInstancedGroupNode new.
	renderable := WDInstancedGeometryBuilder new 
		material: self wodenMaterial;
		addConeRadius: 1.0 height: 2.0 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		makeRenderable.
	self setupRenderableTransparency: renderable.
	node baseShape: renderable.
	^ node