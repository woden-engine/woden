accessing
depthEnabled: aBoolean
	depthEnabled ~= aBoolean ifTrue: [ self changed ].
	depthEnabled := aBoolean