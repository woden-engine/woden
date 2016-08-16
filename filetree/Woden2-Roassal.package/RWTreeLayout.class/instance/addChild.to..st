private
addChild: child to: parent
	| collection |
	collection := children at: parent ifAbsent: [ collection := OrderedCollection new. children at: parent put: collection ].
	collection add: child