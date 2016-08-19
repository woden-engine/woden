comparing
closeTo: other
	^ (x closeTo: other x) and:
	[ (y closeTo: other y) and:
	[ (z closeTo: other z) and:
	[ (w closeTo: other w) ] ] ]