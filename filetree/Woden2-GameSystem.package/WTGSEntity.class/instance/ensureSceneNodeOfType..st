adding
ensureSceneNodeOfType: nodeType
	| nodes |
	nodes := components at: #sceneNode ifAbsentPut: [ OrderedCollection new ].
	(nodes isEmpty or: [ nodes first class ~~ nodeType]) ifTrue: [
		self flag: 'Notify the removal of the old nodes'.
		nodes removeAll.
		self addComponent: (WTGSSceneNode new node: nodeType new).
	]