as yet unclassified
createGrid
	baseGridSize := 10.0.
	primaryGrid := WTSSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: editor primaryGridMesh.
			
	secondaryGrid := WTSSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: editor secondaryGridMesh.
		
	centerAxis := WTSSpatialObject new
		model: (WTGLevelEditorElementModel new view: self);
		renderable: editor centerAxisMesh.

	self scene
		add: secondaryGrid;
		add: primaryGrid;
		add: centerAxis
