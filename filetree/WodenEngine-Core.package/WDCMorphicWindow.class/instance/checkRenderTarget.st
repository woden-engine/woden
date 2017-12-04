initialization
checkRenderTarget
	| innerExtent |
	renderTarget ifNil: [
		self createRenderTarget
	].

	innerExtent := self drawingSurfaceExtent.
	renderTarget extent: innerExtent.
	resolveRenderTarget extent: innerExtent.
	(displayForm isNil or: [ displayForm extent ~= innerExtent ]) ifTrue: [
		displayForm := Form extent: innerExtent depth: 32
	]