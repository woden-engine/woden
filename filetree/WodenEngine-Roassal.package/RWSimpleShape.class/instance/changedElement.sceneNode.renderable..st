changing shape
changedElement: element sceneNode: sceneNode renderable: renderable
	sceneNode isInstance ifFalse: [ ^ self ].
	sceneNode shapeTransform: (self shapeTransformFor: element);
		color: (self colorFor: element).