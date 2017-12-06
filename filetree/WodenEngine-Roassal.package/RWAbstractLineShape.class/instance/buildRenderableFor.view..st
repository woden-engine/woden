hooks
buildRenderableFor: anElement view: aView
	| baseShape component |
	baseShape := aView baseShapeNodeFor: self baseShapeDescriptor ifAbsentPut: [ self createBaseShapeNode ].
	component := self createComponent: baseShape for: anElement.
	^ component