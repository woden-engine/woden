hooks
createBaseShapeNodeForView: aView
	| node renderable engine |
	node := WTSSpatialObjectInstanceGroup new.
	node updatedPerFrame: false.
	engine := aView engine.
	
	renderable := (WTGenericMeshBuilder for: engine)
		material: (self wodenMaterialForView: aView);
		addConeRadius: 1.0 height: 2.0 segments: self class defaultSegments slices: self class defaultSlices;
		computeBoundingBox;
		mesh.

	self setupTransparency: node renderable: renderable.
	node renderable: renderable.		
	^ node