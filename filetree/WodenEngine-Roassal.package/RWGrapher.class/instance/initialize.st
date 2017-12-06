as yet unclassified
initialize
	super initialize.
	
	"Collection of data sets"
	datasets := OrderedCollection new.

	minX := 0.
	minY := 0.
	minZ := 0.
	maxX := 0.
	maxY := 0.
	maxZ := 0.
	
	extent := 15 @ 10.