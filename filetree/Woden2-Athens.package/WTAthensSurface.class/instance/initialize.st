initialization
initialize
	super initialize.
	vertices := NativeOrderedCollection for: WTCanvasVertex2D.
	indices := NativeOrderedCollection for: #int.
	viewportUniformData := WTCanvasViewportUniformData new
		viewMatrix: WMMatrix4F identity;
		projectionMatrix: WMMatrix4F identity;
		yourself.
	deferredDrawCommands := OrderedCollection new.
	pathTransform := WTAthensTransform new loadIdentity.
	pathTessellatorBackend := WTAthensSurfaceMeshPathBuilderBackend new surface: self.
	pathTessellator := WTAthensSoftwareTessellatedPathBuilder new
		transformation: pathTransform;
		backend: pathTessellatorBackend;
		yourself.
	strokePathTessellatorBackend := WTAthensSurfaceThinLinePathBuilderBackend new surface: self.
	strokePathTessellator := WTAthensSoftwareTessellatedPathBuilder new
		transformation: pathTransform;
		backend: strokePathTessellatorBackend;
		yourself.
	blendMode := #alphaOver.
	