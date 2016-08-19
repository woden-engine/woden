as yet unclassified
createPointEntityNode
	| scene |
	worldEntity ifTrue: [ ^ self ].
	pointEntityNode ifNotNil: [ ^ self ].
	scene := self scene.
	scene ifNil: [ ^ self ].
	
	Transcript show: 'createPointEntityNode'; cr.
	pointEntityNode := WTSLocalShapedSpatialObject new.
	pointEntityNode color: self currentColor.
	pointEntityNode shapeTransform: self pointEntityShapeTransform.
	map pointEntityInstanceGroup addChild: pointEntityNode.