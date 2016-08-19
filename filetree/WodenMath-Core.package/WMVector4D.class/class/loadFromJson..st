serialization
loadFromJson: jsonData
	^ self
		x: (jsonData at: 1) asNativeDouble
		y: (jsonData at: 2) asNativeDouble
		z: (jsonData at: 3) asNativeDouble
		w: (jsonData at: 4) asNativeDouble