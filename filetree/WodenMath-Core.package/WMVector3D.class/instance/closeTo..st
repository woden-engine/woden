comparing
closeTo: other
	<argument: #other type: #(SelfType object)>
	^ (x closeTo: other x) and: [ (y closeTo: other y) and: [z closeTo: other z] ]