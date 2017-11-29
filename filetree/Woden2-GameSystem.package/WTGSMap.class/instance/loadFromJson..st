serialization
loadFromJson: jsonData
	jsonData at: 'background-color' ifPresent: [ :colorJson |
		backgroundColor := Color loadWodenJsonData: colorJson
	].

	jsonData at: 'entities' ifPresent: [ :entitiesJson |
		entitiesJson do: [:entityJson | self addEntity: (WTGSEntity loadFromJson: entityJson) ] 
	]