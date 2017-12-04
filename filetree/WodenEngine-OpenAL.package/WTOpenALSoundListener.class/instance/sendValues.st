as yet unclassified
sendValues
	| forward up orientationData |
	device asCurrentDo: [
		OpenAL
			listener3f: AL_POSITION value: position x value: position y value: position z;
			listener3f: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
		
		forward := orientation transformVector3: (WMVector3F z: -1.0).
		up := orientation transformVector3: (WMVector3F y: 1.0).
	
		orientationData := {
			forward x . forward y . forward z .
			up x . up y . up z} asFloatArray.
		OpenAL listenerfv: AL_ORIENTATION values: orientationData.
	]