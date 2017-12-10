adding
updateSceneNode
	entity sceneNodesDo: [ :node |
		node isLightSource ifTrue: [ 
			node perform: type.
			node state
				intensity: intensity.
			type == #spot ifTrue: [ 
				node innerSpotCutoff: innerSpotCutoff;
					outerSpotCutoff: outerSpotCutoff.
			]
		]
	]