serialization
loadFromJson: jsonData
	modelName := jsonData at: 'model' ifAbsent: [ '' ]
