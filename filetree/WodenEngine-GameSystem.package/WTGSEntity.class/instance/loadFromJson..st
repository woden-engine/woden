serialization
loadFromJson: jsonData
	| comp |
	worldEntity := jsonData at: 'world' ifAbsent: [ false ].
	jsonData at: 'components' ifPresent: [ :componentsJson |
		componentsJson do: [ :componentJson |
			comp := WTGSComponent loadFromJson: componentJson.
			comp ifNotNil: [ self addComponent: comp ]
		]
	]