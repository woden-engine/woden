instance creation
checkRenderTargets
	| mainTarget extent extentChanged |
	leftRenderTarget ifNil: [ 
		self createRenderTargets.
	].

	mainTarget := view window validResolveRenderTarget.
	extent := mainTarget extent.

	extentChanged := extent ~= leftRenderTarget extent.
	extentChanged ifTrue: [ 
		leftRenderTarget extent: extent.
		leftResolveRenderTarget ~~ leftRenderTarget ifTrue: [ leftResolveRenderTarget extent: extent].
		rightRenderTarget extent: extent.
		rightResolveRenderTarget ~~ rightRenderTarget ifTrue: [ rightResolveRenderTarget extent: extent].
	].

	(sourceRenderTargetsBinding isNil or: [ extentChanged ]) ifTrue: [ 
		sourceRenderTargetsBinding ifNil: [
			sourceRenderTargetsBinding := self shaderSignature newSource
		].
		sourceRenderTargetsBinding
			bind: 0 renderTarget: leftResolveRenderTarget startMiplevel: 0 miplevels: -1 lodclamp: 100000.0;
			bind: 1 renderTarget: rightResolveRenderTarget startMiplevel: 0 miplevels: -1 lodclamp: 100000.0.
	]
