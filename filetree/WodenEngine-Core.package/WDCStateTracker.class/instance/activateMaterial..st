commands
activateMaterial: material
	activeMaterial == material ifTrue: [ ^ true ].
	
	(material activateOn: self) ifTrue: [ 
		activeMaterial := material.
		^ true
	] ifFalse: [
		^ false
	]
	