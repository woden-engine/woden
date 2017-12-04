rendering preparations
sortObjects: objectList perViewports: viewports
	| viewport forwardDirection translucentSortedPriority |
	translucentSortedPriority := WTSNode renderPriorityTranslucentSorted.
	
	objectList doWithIndex: [ :objects :index |
		viewport := viewports at: index.
		forwardDirection := viewport camera renderTransform matrix thirdColumn negated.
		objects sort: [ :a :b |
			a renderPriority = b renderPriority ifFalse: [
				a renderPriority < b renderPriority
			] ifTrue: [
				a renderPriority >= translucentSortedPriority ifTrue: [ 
					(forwardDirection dot: a renderTransform translation) > (forwardDirection dot: b renderTransform translation)
				] ifFalse: [ false ]
			]
		]
	].
