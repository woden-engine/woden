selection
findBestElementAtWindowCoord: coord
	| ray bestResult |
	ray := self rayAtWindowCoord: coord.
	bestResult := nil.
	self elementsAlongRay: ray do: [ :result |
		(bestResult isNil or: [ result < bestResult ]) ifTrue: [ 
			bestResult := result
		]
	].

	^ bestResult
