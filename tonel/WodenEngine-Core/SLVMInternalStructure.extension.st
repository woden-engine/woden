Extension { #name : #SLVMInternalStructure }

{ #category : #'*WodenEngine-Core' }
SLVMInternalStructure class >> asWodenVertexLayout [
	^ WDCVertexLayout new buffers: { self asWodenVertexStructureDescription }
]

{ #category : #'*WodenEngine-Core' }
SLVMInternalStructure class >> asWodenVertexStructureDescription [
	| desc |
	desc := WDCStructureDescription new
		name: self name;
		size: self structureSize;
		alignment: self structureAlignment.
	desc fields: (self slots collect: [ :slot |
		WDCStructureField new
			name: slot name;
			offset: slot offset;
			binding: (slot propertyAt: #vertexLocation);
			type: (WDCStructureFieldType typeNamed: (slot propertyAt: #vertexFormat));
			yourself
	]).
	^ desc
]
