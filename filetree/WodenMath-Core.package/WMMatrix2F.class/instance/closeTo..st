comparing
closeTo: other
	<argument: #other type: #(SelfType object)>
	^ (m11 closeTo: other m11) and:
		[ (m12 closeTo: other m12) and:
		
		[ (m21 closeTo: other m22) and:
		[ (m22 closeTo: other m22) ]]]