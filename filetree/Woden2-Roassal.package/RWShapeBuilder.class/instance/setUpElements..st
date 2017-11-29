building
setUpElements: elements
	self hasSetShape ifFalse: [ self box ].
	^ elements do: [ :e | e shape: shape ]