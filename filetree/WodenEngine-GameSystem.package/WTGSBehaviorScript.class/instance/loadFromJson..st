serialization
loadFromJson: jsonData
	self spawnCode: (jsonData at: 'spawn-code' ifAbsent: [''] )