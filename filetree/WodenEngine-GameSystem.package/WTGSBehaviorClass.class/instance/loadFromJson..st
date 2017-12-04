serialization
loadFromJson: jsonData
	self behaviorClassName: (jsonData at: 'class' ifAbsent: [''])