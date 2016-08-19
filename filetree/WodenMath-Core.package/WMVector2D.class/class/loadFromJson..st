serialization
loadFromJson: jsonData
	^ self
		x: (jsonData at: 1) asNativeDouble
		y: (jsonData at: 2) asNativeDouble