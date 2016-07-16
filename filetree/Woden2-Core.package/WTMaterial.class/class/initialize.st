as yet unclassified
initialize
	super initialize.
	
	PrimitiveTypeToStateSuffix := Dictionary newFromPairs: { 
		AGPU_POINTS . #'.points' .
		AGPU_LINES . #'.lines' .
		AGPU_TRIANGLES . #'.triangles' .
		AGPU_PATCHES . #'.patches' .
	}