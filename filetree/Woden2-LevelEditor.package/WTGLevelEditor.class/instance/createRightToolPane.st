rendering
createRightToolPane
	| materialListView textureTransformView |
	textureTransformView := WTGLevelEditorTextureTransformView new.
	
	materialListView := WTGLevelEditorMaterialListView for: self.
	materialListView
		constraintsDo:[:c| c vhMatchParent ; alignCenter.].
	^ BrVBoxPane new
		background: Color gray;
		constraintsDo:[:c| c vhMatchParent ; alignCenter; weight: 1];
		addChildren: { "textureTransformView bloc . "materialListView}