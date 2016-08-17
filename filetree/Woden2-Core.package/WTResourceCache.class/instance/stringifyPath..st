private
stringifyPath: aPath
	| first |
	first := true.
	^ String streamContents: [ :out |
		aPath do: [ :component |
			first ifFalse: [ out nextPut: $/ ].
			first := false.
			out nextPutAll: component
		]
	]