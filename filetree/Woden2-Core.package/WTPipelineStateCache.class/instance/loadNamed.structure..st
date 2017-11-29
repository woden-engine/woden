state loading
loadNamed: name structure: structureDesc
	| structure field fieldType |
	structure := WTStructureDescription new.
	structure 
		name: name asSymbol;
		size: 0;
		alignment: 1;
		type: (structureDesc at: 'type') asSymbol.
	structure fields: ((structureDesc at: 'fields') collect: [ :fieldDesc |
		"Align the structure size to the field type alignment"
		fieldType := WTStructureFieldType typeNamed: (fieldDesc at: 'format').
		structure size: (structure size alignedTo: fieldType alignment).
		
		"Construct the field"
		field := WTStructureField new
			name: (fieldDesc at: 'name');
			type: fieldType;
			offset: structure size;
			binding: (fieldDesc at: 'binding');
			yourself.
		
		"Update the structure size and alignment"	
		structure size: structure size + fieldType size.
		structure alignment: (structure alignment max: fieldType alignment).
		field
	]).
	
	structure size: (structure size alignedTo: structure alignment).
	structures at: structure name put: structure.
