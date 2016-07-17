selection
elementsAlongRay: ray do: aBlock
	| distance model |
	distance := nil.
	manipulatorBoxes doWithIndex: [ :box :index |
		(box isEmpty not and: [ (distance := ray intersectionDistanceWithBox: box) isNotNil ]) ifTrue: [
			model := (manipulatorNodes at: index) model.
			aBlock value: (WMRayIntersectionTestResult priority: -1 distance: distance value: model)
		]
	].