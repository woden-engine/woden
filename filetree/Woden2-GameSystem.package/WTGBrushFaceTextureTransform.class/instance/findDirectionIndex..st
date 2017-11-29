private
findDirectionIndex: aVector
	| best bestIndex amount |
	best := -5.
	bestIndex := -1.
	1 to: 6 do: [ :i |
		amount := aVector dot: (VectorDirections at: i).
		amount > best ifTrue: [ 
			best := amount.
			bestIndex := i.
		]
	].

	self assert: bestIndex >= 1.
	^ bestIndex