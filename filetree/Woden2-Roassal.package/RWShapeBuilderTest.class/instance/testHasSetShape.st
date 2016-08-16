hasSetShape
testHasSetShape

	"self deny: builder hasSetShape."
	builder rectangle.
	self assert: builder hasSetShape.
	"self deny: builder hasSetLineShape.
	
	builder line.
	self assert: builder hasSetShape.
	self assert: builder hasSetLineShape."