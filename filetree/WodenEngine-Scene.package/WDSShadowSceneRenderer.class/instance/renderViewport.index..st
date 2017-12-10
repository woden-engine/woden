rendering
renderViewport: viewport index: viewportIndex
	| renderTarget resolveTarget renderPass |
	renderTarget := viewport renderTarget.
	resolveTarget := viewport resolveRenderTarget.

	renderPass := renderTarget validMainRenderPass.
	
	"Begin rendering into the viewport"
	stateTracker
		beginRenderPass: renderPass renderTarget: renderTarget bounds: viewport bounds.
	self setupViewportRendering: viewport index: viewportIndex.
	
	"Render the viewport objects"
	(objectsPerViewport at: viewportIndex) do: [ :object |
		object renderOn: stateTracker
	].
	
	"End rendering into the viewport"
	stateTracker endRenderPass.