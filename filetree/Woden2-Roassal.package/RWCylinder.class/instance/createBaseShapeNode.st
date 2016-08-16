hooks
createBaseShapeNode
	| node renderable |
	node := WDInstancedGroupNode new.
	renderable := WDInstancedGeometryBuilder new 
		material: self wodenMaterial;
		addCylinderRadius: 0.5 height: 1.0 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		makeRenderable.
	self setupRenderableTransparency: renderable.
	node baseShape: renderable.
	^ node