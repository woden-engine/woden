as yet unclassified
deletePointEntityNode
	(map isNil or: [ map editorMode not ]) ifTrue: [ ^ self ].
	pointEntityNode ifNil: [ ^ self ].
	pointEntityNode removeFromScene.
	pointEntityNode := nil