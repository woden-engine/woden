serialization
loadFromJson: jsonData
	^ self
		nx: (jsonData at: 1) asNativeDouble
		ny: (jsonData at: 2) asNativeDouble
		nz: (jsonData at: 3) asNativeDouble
		d: (jsonData at: 4) asNativeDouble