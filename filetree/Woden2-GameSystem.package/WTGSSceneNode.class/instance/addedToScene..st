adding
addedToScene: anScene
	(anScene isNil or: [ node scene == anScene ]) ifTrue: [ ^ self ].
	node removeFromScene.
	anScene add: node