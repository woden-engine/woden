as yet unclassified
createGrid
	| engine gridMaterial primaryGridMesh secondaryGridMesh |
	engine := self engine.
	gridMaterial := engine resourceCache loadMaterial: 'materials/basic/editor-grid.json'.
	baseGridSize := 10.0.
	primaryGridMesh := (WTGenericMeshBuilder for: engine)
		material: gridMaterial;
		color: Color gray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 21;
		mesh.
		
	secondaryGridMesh := (WTGenericMeshBuilder for: engine)
		material: gridMaterial;
		color: Color darkGray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 201;
		mesh.

	primaryGrid := WTSSpatialObject new
		model: self;
		renderable: primaryGridMesh.
			
	secondaryGrid := WTSSpatialObject new
		model: self;
		renderable: secondaryGridMesh.

	self scene add: secondaryGrid.
	self scene add: primaryGrid.
