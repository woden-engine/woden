as yet unclassified
loadAndSetModel
	| sceneNodeComponent |
	entity ifNil: [ ^ self ].
	self scene ifNil: [ ^ self ].
	sceneNodeComponent := entity sceneNodeComponent.
	sceneNodeComponent ifNil: [ ^ self ].
	model ifNil: [
		self loadModel
	].

	model ifNotNil: [
		sceneNodeComponent node renderable: model.
	]