rendering preparations
collectVisibleObjectsFor: camera from: node
	node visible ifFalse: [ ^ self ].
	
	visibleObjects add: node.
	node isLightSource ifTrue: [ self tryToCollectLightSource: node for: camera ].
	
	node isInstanceGroup ifFalse: [
		node children do: [:child |
			self collectVisibleObjectsFor: camera from: child
		]
	]