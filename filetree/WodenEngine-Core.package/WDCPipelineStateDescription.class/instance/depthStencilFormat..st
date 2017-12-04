accessing
depthStencilFormat: newDepthStencilFormat
	depthStencilFormat ~= newDepthStencilFormat ifTrue: [ self changed ].
	depthStencilFormat := newDepthStencilFormat