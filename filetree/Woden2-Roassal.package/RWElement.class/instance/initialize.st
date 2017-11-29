initialization
initialize
	super initialize.
	behaviors := OrderedCollection new.
	sceneNode := self createSceneNode.
	shape := RWNullShape new.
