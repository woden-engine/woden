as yet unclassified
createPointEntityNode
	| scene |
	(map isNil or: [ map editorMode not ]) ifTrue: [ ^ self ].
	worldEntity ifTrue: [ ^ self ].
	pointEntityNode ifNotNil: [ ^ self ].
	scene := self scene.
	scene ifNil: [ ^ self ].
	
	pointEntityNode := WTSLocalShapedSpatialObject new.
	pointEntityNode color: self currentColor.
	pointEntityNode shapeTransform: self pointEntityShapeTransform.
	self spatialDescription ifNotNil: [ :desc | pointEntityNode transform: desc transform ].
	map pointEntityInstanceGroup addChild: pointEntityNode.