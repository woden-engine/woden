as yet unclassified
deletePointEntityNode
	pointEntityNode ifNil: [ ^ self ].
	pointEntityNode removeFromScene.
	pointEntityNode := nil