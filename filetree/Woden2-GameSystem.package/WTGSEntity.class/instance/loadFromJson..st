serialization
loadFromJson: jsonData
	| comp |
	jsonData at: 'components' ifPresent: [ :componentsJson |
		componentsJson do: [ :componentJson |
			comp := WTGSComponent loadFromJson: componentJson.
			comp ifNotNil: [ self addComponent: comp ]
		]
	]