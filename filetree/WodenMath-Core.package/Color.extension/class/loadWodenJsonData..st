*WodenMath-Core
loadWodenJsonData: jsonData
	jsonData isString ifTrue: [ ^ self fromString: jsonData ].
	^ WMVector4F loadFromJson: jsonData