accessing
renderTargetFormats: newRenderTargetFormats
	renderTargetFormats ~= newRenderTargetFormats ifTrue: [ self changed ].
	renderTargetFormats := newRenderTargetFormats