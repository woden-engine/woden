class initialization
initialize
	super initialize.
	PerspectiveNearDistance := 0.01.
	PerspectiveFarDistance := 10000.0.
	
	OrthographicNearDistance := -10000.0.
	OrthographicFarDistance := OrthographicNearDistance negated.
