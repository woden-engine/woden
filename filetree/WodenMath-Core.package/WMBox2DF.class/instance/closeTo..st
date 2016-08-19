comparing
closeTo: other
	<argument: #other type: #(SelfType object)>
	^ (min closeTo: other min) and: [ max closeTo: other max ]