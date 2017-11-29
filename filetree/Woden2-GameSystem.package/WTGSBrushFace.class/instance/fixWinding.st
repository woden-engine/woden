as yet unclassified
fixWinding
 	| normal center positions |
	center := self center.
	normal := plane normal.
	positions := brush positions.
	
	indices sort: [ :first :second |
		| a b u v |
		a := positions at: first + 1.
		b := positions at: second + 1.
		u := a - center.
		v := b - center.
		((u cross: v) dot: normal) >= Epsilon negated
	].
