position calculation
positionsFor: aDimension onLayerSized: aNumber
	| positions corner partSize |
	aNumber = 1 ifTrue: [ ^ { 0 @ 0 } ].
	
	partSize := aNumber - 1.
	positions := OrderedCollection new: partSize * 4.
	
	corner := aDimension x @ aDimension z * partSize / 2.
	
	
	{ aDimension x negated @ 0 .
	                     0 @ aDimension z negated .
	          aDimension x @ 0 .
	                     0 @ aDimension z } do: [ :shift |
		
		partSize timesRepeat: [
			positions add: corner.
			corner := corner + shift ]].
	
	
	^ positions asArray