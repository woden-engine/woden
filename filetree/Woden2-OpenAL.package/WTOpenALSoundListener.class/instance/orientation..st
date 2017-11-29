accessing
orientation: anObject
	| forward up orientationData |
	orientation := anObject.
	
	(self hasValidHandle and: [ self isCurrentListener ]) ifTrue: [
		forward := orientation transformVector3: (WMVector3F z: -1.0).
		up := orientation transformVector3: (WMVector3F y: 1.0).
	
		orientationData := {
			forward x . forward y . forward z .
			up x . up y . up z} asFloatArray.
			
		device asCurrentDo: [
			OpenAL listenerfv: AL_ORIENTATION values: orientationData.
		]
	]