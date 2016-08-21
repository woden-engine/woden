serialization
loadFromJson: jsonData
	jsonData at: 'entities' ifPresent: [ :entitiesJson |
		entitiesJson do: [:entityJson | self addEntity: (WTGSEntity loadFromJson: entityJson) ] 
	]