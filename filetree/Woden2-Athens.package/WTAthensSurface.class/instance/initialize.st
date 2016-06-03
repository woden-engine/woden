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