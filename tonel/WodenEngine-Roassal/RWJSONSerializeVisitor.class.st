Class {
	#name : #RWJSONSerializeVisitor,
	#superclass : #RWAbstractVisitor,
	#instVars : [
		'idDictionary',
		'idCount'
	],
	#category : #'WodenEngine-Roassal-Serialization'
}

{ #category : #visiting }
RWJSONSerializeVisitor >> encodeElementShape: anElement [ 
	^ Dictionary newFromPairs: {
		#extent . self encodeVector3: anElement extent.
		#shapeDescription . self visitObject: anElement shape
	}
]

{ #category : #serialization }
RWJSONSerializeVisitor >> encodeVector3: aVector3 [
	^ { aVector3 x . aVector3 y . aVector3 z }
]

{ #category : #serialization }
RWJSONSerializeVisitor >> encodeVector4: aVector4 [
	^ { aVector4 x . aVector4 y . aVector4 z . aVector4 w }
]

{ #category : #visiting }
RWJSONSerializeVisitor >> idForElement: element [
	^ idDictionary at: element ifAbsentPut: [ idCount := idCount + 1 ]
]

{ #category : #visiting }
RWJSONSerializeVisitor >> initialize [
	super initialize.
	idCount := -1.
	idDictionary := IdentityDictionary new.
	
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitCamera: aCamera [
	^ Dictionary newFromPairs: {
		#id . self idForElement: aCamera.
		#type . #camera.
		#position . self encodeVector3: aCamera position.
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitCubeShape: aCubeShape [
	^ #cube
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitEdge: anElement [
	^ Dictionary newFromPairs: {
		#id . self idForElement: anElement.
		#from_id . self idForElement: anElement from.
		#to_id . self idForElement: anElement to.
		#type . #edge.
		#color . self encodeVector4: anElement colorUsedForRendering.
		#shape . self encodeElementShape: anElement 
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitElement: anElement [
	^ Dictionary newFromPairs: {
		#id . self idForElement: anElement.
		#type . #element.
		#position . self encodeVector3: anElement position.
		#color . self encodeVector4: anElement colorUsedForRendering.
		#shape . self encodeElementShape: anElement 
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitLineShape: aCubeShape [
	^ #line
]
