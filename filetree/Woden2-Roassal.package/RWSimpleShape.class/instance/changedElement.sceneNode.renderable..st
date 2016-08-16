changing shape
changedElement: element sceneNode: sceneNode renderable: renderable
	"Weird!!! We should not do that"
	sceneNode class ~~ WDInstancedNode ifTrue: [ ^ self ].
	
	sceneNode shapeMatrix: (self shapeMatrixFor: element);
		color: (self colorFor: element).