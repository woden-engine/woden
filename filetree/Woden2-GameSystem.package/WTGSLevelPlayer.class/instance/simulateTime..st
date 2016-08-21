as yet unclassified
simulateTime: delta
	super simulateTime: delta.
	map ifNotNil: [ map simulateTime: delta ].