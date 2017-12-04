iterating elements
componentsDoWithIndex: aBlock
	| index |
	index := 1.
	components valuesDo: [ :list |
		list do: [:comp |
			aBlock value: comp value: index.
			index := index + 1
		]
	]