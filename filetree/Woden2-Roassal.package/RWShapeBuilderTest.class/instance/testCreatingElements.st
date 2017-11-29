created elements
testCreatingElements
	builder rectangle.
	self assert: builder createdElements size = 0.
	builder elementsOn: (1 to: 10).
	self assert: builder createdElements size = 10.
	builder reset.
	self assert: builder createdElements size = 0.