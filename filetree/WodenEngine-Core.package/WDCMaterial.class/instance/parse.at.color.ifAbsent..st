parsing
parse: data at: fileReference color: name ifAbsent: aBlock
	^ data at: name
		ifPresent: [ :colorData |
				colorData isString ifTrue: [
					self halt
				] ifFalse: [
					WMVector4F x: (colorData at: 1) 
							y: (colorData at: 2)
							z: (colorData at: 3)
							w: (colorData at: 4 ifAbsent: [ 1.0 ])
				] 
		]
		ifAbsent: [ aBlock value asWMVector4F ] .
	