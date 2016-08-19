serialization
loadFromJson: jsonData
	^ self
		nx: (jsonData at: 1) asNativeDouble
		ny: (jsonData at: 2) asNativeDouble
		nz: (jsonData at: 3) asNativeDouble
		px: (jsonData at: 4) asNativeDouble
		py: (jsonData at: 5) asNativeDouble
		pz: (jsonData at: 6) asNativeDouble
