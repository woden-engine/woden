accessing
createPointEntityInstanceGroup
	pointEntityInstanceGroup := WTSSpatialObjectInstanceGroup new.
	pointEntityInstanceGroup
		updatedPerFrame: false;
		renderable: ((WTGenericMeshBuilder for: scene engine)
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh).
	scene add: pointEntityInstanceGroup