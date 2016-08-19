as yet unclassified
loadFromJson: jsonData
	^ self
		x: (jsonData at: 1) asNativeFloat
		y: (jsonData at: 2) asNativeFloat
		z: (jsonData at: 3) asNativeFloat
		w: (jsonData at: 4) asNativeFloat