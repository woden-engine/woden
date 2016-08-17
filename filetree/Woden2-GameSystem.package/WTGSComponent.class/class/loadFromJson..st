serialization
loadFromJson: jsonData
	JsonTypeMap ifEmpty: [ self initialize ].
	^ (JsonTypeMap at: (jsonData at: 'type') ifAbsent: [ ^ nil ]) new loadFromJson: jsonData