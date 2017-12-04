adding
removedFromScene: anScene
	node scene == anScene ifTrue: [
		node removeFromScene.
	]