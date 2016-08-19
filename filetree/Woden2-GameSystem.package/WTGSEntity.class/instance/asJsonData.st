serialization
asJsonData
	| compJson |
	^ OrderedDictionary newFromPairs: {
		'world' . worldEntity .
		'components' . Array streamContents: [:out | 
			components valuesDo: [:list |
				list do: [:comp |
					compJson := comp asJsonData.
					compJson ifNotNil: [ out nextPut: compJson ].
				] 
			]
		]
	 }