comparing
closeTo: other
	<argument: #other type: #(SelfType object)>
	^ (m11 closeTo: other m11) and:
		[ (m12 closeTo: other m12) and:
		[ (m13 closeTo: other m13) and:
		
		[ (m21 closeTo: other m21) and:
		[ (m22 closeTo: other m22) and:
		[ (m23 closeTo: other m23) and:

		[ (m31 closeTo: other m31) and:
		[ (m32 closeTo: other m32) and:
		[ (m33 closeTo: other m33) ]]]]]]]]
