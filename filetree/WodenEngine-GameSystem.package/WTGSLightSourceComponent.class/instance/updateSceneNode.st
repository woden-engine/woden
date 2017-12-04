adding
updateSceneNode
	entity sceneNodesDo: [ :node |
		node isLightSource ifTrue: [ 
			node perform: type.
			node state
				intensity: intensity.
			type == #spot ifTrue: [ 
				node state
					innerCosCutoff: innerSpotCutoff degreeCos;
					outerCosCutoff: outerSpotCutoff degreeCos.
			]
		]
	]