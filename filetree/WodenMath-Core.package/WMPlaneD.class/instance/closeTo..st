comparing
closeTo: other
	^ (nx closeTo: other nx) and: 
		[ (ny closeTo: other ny) and:
		[ (nz closeTo: other nz) and:
		[ d closeTo: other d ]]]