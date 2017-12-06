instance creation
checkRenderTargets
	| innerExtent |
	renderTarget ifNil: [
		self createRenderTarget
	].

	innerExtent := self drawingSurfaceExtent.
	renderTarget extent: innerExtent.
	resolveRenderTarget extent: innerExtent.