pipeline state object building
setPipeline: builder primitiveTypeNamed: primitiveTypeName
	| primitiveType |
	primitiveType := PrimitiveTopologyNameMap at: primitiveTypeName asSymbol ifAbsent: [ 
		self error: 'Unknown primitive type ', primitiveTypeName printString.
	].
	
	builder setPrimitiveType: primitiveType.