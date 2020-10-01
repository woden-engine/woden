Class {
	#name : #WDCVertexDataStructure,
	#superclass : #SysmelStructureType,
	#category : #'WodenEngine-NativeStructures-Core-Mesh'
}

{ #category : #converting }
WDCVertexDataStructure class >> asWodenVertexLayout [
	^ WDCVertexLayout new buffers: { self asWodenVertexStructureDescription }
]

{ #category : #converting }
WDCVertexDataStructure class >> asWodenVertexStructureDescription [
	| desc |
	desc := WDCStructureDescription new
		name: self name;
		size: self instanceSize;
		alignment: self instanceAlignment.
	desc fields: (self aggregateLayout slots collect: [ :slot |
		WDCStructureField new
			name: slot name;
			offset: slot offset;
			binding: slot location;
			type: (WDCStructureFieldType typeNamed: slot type asWodenVertexFormat);
			yourself
	]).
	^ desc
]

{ #category : #testing }
WDCVertexDataStructure class >> isAbstract [
	^ self == WDCVertexDataStructure
]
