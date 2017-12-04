accessing
depthWriteMask: newDepthWriteMask
	depthWriteMask ~= newDepthWriteMask ifTrue: [ self changed ].
	depthWriteMask := newDepthWriteMask