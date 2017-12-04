adding
addedToScene: anScene
	self componentsDo: [ :comp | comp addedToScene: anScene ].
	pointEntity ifTrue: [ self createPointEntityNode ].