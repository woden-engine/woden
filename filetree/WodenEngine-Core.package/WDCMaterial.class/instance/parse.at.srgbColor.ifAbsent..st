parsing
parse: data at: fileReference srgbColor: name ifAbsent: aBlock
	^ data at: name
		ifPresent: [ :colorData |
				colorData isString ifTrue: [
					self halt
				] ifFalse: [
					(Color r: (colorData at: 1) 
							g: (colorData at: 2)
							b: (colorData at: 3)
							alpha: (colorData at: 4 ifAbsent: [ 1.0 ])) asWMVector4F
				] 
		]
		ifAbsent: [ aBlock value asWMVector4F ] .
	