Class {
	#name : #RWJSONSerializeVisitor,
	#superclass : #RWAbstractVisitor,
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

{ #category : #visiting }
RWJSONSerializeVisitor >> visitCamera: aCamera [
	^ Dictionary newFromPairs: {
		#type . #camera.
		#position . self encodeVector3: aCamera position.
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitCubeShape: aCubeShape [
	^ #cube
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitElement: anElement [
	^ Dictionary newFromPairs: {
		#type . #element.
		#position . self encodeVector3: anElement position.
		#shape . self encodeElementShape: anElement 
	}
]
