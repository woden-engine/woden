hooks
buildRenderableFor: anElement view: aView
	| baseShape component |
	baseShape := aView baseShapeNodeNamed: self baseShapeName ifAbsentPut: [ self createBaseShapeNode ].
	component := self createComponent: baseShape for: anElement.
	^ component