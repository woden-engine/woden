serialization
loadFromJson: jsonData
	^ (JsonTypeMap at: (jsonData at: 'type') ifAbsent: [ ^ nil ]) new loadFromJson: jsonData