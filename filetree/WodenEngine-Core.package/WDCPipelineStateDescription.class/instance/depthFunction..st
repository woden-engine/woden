accessing
depthFunction: newDepthFunction
	depthFunction ~= newDepthFunction ifTrue: [ self changed ].
	depthFunction := newDepthFunction