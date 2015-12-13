pipeline state object building
setPipeline: builder primitiveTypeNamed: primitiveTypeName
	| primitiveType |
	primitiveType := PrimitiveTypeNameMap at: primitiveTypeName asSymbol ifAbsent: [ 
		self error: 'Unknown primitive type ', shaders printString.
	].
	
	builder setPrimitiveType: primitiveType.