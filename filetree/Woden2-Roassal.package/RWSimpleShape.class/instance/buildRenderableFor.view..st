hooks
buildRenderableFor: anElement view: aView
	| baseShape instance |
	baseShape := aView baseShapeNodeNamed: self baseShapeName ifAbsentPut: [ self createBaseShapeNodeForView: aView ].
	instance := WTSLocalShapedSpatialObject new.
	instance shapeTransform: (self shapeTransformFor: anElement);
		color: (self colorFor: anElement).
	baseShape addChild: instance.
	anElement replaceSceneNode: instance.
	^ nil