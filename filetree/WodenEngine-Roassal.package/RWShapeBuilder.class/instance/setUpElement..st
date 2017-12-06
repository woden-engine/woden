public - building
setUpElement: anElement
	self hasSetShape ifFalse: [ self box ].
	^ anElement shape: shape