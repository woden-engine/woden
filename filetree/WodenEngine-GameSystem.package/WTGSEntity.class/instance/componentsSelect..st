iterating elements
componentsSelect: aBlock
	| result |
	result := OrderedCollection new.
	components valuesDo: [ :list |
		list do: [:comp |
			(aBlock value: comp) ifTrue: [
				result add: comp
			]
		]
	].

	^ result