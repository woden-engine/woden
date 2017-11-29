as yet unclassified
loadVector3: vectorData
	^ WMVector3F
		x: (vectorData at: 1) asFloat
		y: (vectorData at: 2) asFloat
		z: (vectorData at: 3) asFloat