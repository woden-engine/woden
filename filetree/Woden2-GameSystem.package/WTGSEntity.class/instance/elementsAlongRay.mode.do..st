as yet unclassified
elementsAlongRay: ray mode: mode do: aBlock
	| models |
	models := components at: #modeling ifAbsent: [ ^ self ].
	models do: [ :model | model elementsAlongRay: ray mode: mode do: aBlock ]