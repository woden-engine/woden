as yet unclassified
isPointSelection
	^ elements isNotEmpty and: [ elements size = 1 and: [ elements anyOne isPointSelected ] ]