instance creation
close
	window destroy.
	resolveRenderTarget ifNotNil: [
		resolveRenderTarget release.
		renderTarget ~~ resolveRenderTarget ifTrue: [ renderTarget release ].
	].

	resolveRenderTarget := nil.
	renderTarget := nil
