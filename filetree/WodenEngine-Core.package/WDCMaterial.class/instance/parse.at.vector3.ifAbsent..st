parsing
parse: data at: fileReference vector3: name ifAbsent: aBlock
	^ data at: name
		ifPresent: [ :colorData |
					WMVector3F x: (colorData at: 1) 
							y: (colorData at: 2)
							z: (colorData at: 3)
		]
		ifAbsent: [ aBlock value asWMVector3F ] .
	