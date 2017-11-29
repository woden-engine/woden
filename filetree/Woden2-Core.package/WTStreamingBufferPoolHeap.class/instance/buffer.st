accessing
buffer
	buffer ifNil: [ buffer := pool createBuffer: capacity ].
	^ buffer