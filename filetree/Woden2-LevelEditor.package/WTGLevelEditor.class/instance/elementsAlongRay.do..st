selection
elementsAlongRay: ray do: aBlock
	| distance model |
	distance := nil.
	selectionBoxManipulators do: [ :box |
		(box isEmpty not and: [ (distance := ray intersectionDistanceWithBox: box) isNotNil ]) ifTrue: [
			model := WTGLevelEditorBoxManipulator new
				box: box copy;
				direction: (box center - selectionBox center) normalized.
			aBlock value: (WMRayIntersectionTestResult distance: distance value: model)
		]
	].

	map elementsAlongRay: ray do: aBlock