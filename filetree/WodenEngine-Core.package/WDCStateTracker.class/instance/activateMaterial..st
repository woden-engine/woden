commands
activateMaterial: material
	activeMaterial == material ifTrue: [ ^ true ].
	
	self materialBlendingMode: nil.
	(material activateOn: self) ifTrue: [ 
		activeMaterial := material.
		^ true
	] ifFalse: [
		^ false
	]
	