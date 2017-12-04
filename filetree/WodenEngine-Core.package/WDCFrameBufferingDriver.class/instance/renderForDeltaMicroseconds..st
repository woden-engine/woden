rendering process
renderForDeltaMicroseconds: delta
	"Always update the simulations"
	self renderingProcessesDo: [ :process | process updateForDeltaMicroseconds: delta ].

	"Only perform rendering if there is at least one process that needs to perform rendering."
	frontRenderingProcesses detect: #needsToRender ifNone: [^ self].
	
	self newFrame.
	self renderingProcessesRenderDo: #prepareRendering.
	self renderingProcessesRenderDo: #sendRenderingCommands.
	self renderingProcessesRenderDo: #commitSurfaces.