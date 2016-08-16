as yet unclassified
createBaseShapeNode
	| node renderable |
	node := WDInstancedGroupNode new.
	renderable := WDInstancedGeometryBuilder new 
		material: self wodenMaterial;
		addUVSphereRadius: 0.5 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		makeRenderable.
	self setupRenderableTransparency: renderable.
	node baseShape: renderable.
	^ node