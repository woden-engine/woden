rendering
depthSortFor: aCamera
	| forwardDirection |
	forwardDirection := (aCamera renderTransform matrix * renderTransform matrix) thirdColumn negated.
	"(lastForwardDirection closeTo: forwardDirection) ifTrue: [ ^ self ]."
	lastForwardDirection := forwardDirection.
		
	children do: #updateRenderTransform.
	self renderPriority >= WTSNode renderPriorityTranslucentSorted ifTrue: [
		children sort: [ :a :b |
			(forwardDirection dot: a renderTransform translation) < (forwardDirection dot: b renderTransform translation)
		]
	] ifFalse: [ 
		children sort: [ :a :b |
			(forwardDirection dot: a renderTransform translation) > (forwardDirection dot: b renderTransform translation)
		]
	]