initialization
initialize
	super initialize.
	rigidBodies := OrderedCollection new.
	kinematicObjects := OrderedCollection new.
	onSimulation := false.