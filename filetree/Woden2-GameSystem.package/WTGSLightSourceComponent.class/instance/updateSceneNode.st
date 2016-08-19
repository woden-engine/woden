adding
updateSceneNode
	entity sceneNodesDo: [ :node |
		node isLightSource ifTrue: [ 
			node state
				intensity: intensity.
		]
	]