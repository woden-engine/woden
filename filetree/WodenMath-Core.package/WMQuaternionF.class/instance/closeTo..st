comparing
closeTo: other
	<argument: #other type: #(SelfType object)>
	^ (r closeTo: other r) and:
	[ (i closeTo: other i) and:
	[ (j closeTo: other j) and:
	[ (k closeTo: other k) ]]]