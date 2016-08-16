changing shape
changedElement: element sceneNode: sceneNode renderable: renderable
	sceneNode isInstancedGroup ifFalse: [ ^ self ].
	
	sceneNode shapeTransform: (self shapeTransformFor: element);
		color: (self colorFor: element).