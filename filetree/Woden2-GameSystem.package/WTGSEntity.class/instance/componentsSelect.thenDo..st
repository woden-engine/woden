iterating elements
componentsSelect: aBlock thenDo: doBlock
	components valuesDo: [ :list |
		list do: [:comp |
			(aBlock value: comp) ifTrue: [
				doBlock value: comp
			]
		]
	].
