Class {
	#name : #RWJSONSerializeVisitor,
	#superclass : #RWAbstractVisitor,
	#category : #'WodenEngine-Roassal-Serialization'
}

{ #category : #'as yet unclassified' }
RWJSONSerializeVisitor >> encodeColor: arg1 [
	| t |
	t := arg1 asWMVector4F.
	^ {t x.
	t y.
	t z.
 t w}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> encodeElementInteractions: anElement [
	| interactions |
	interactions := anElement attributeAt: #interactions ifAbsent: [#()].
	^ interactions collect: [ :interaction | interaction accept: self ]
]

{ #category : #visiting }
RWJSONSerializeVisitor >> encodeElementShape: anElement [ 
	^ Dictionary newFromPairs: {
		#extent . self encodeVector3: anElement extent.
		#shapeDescription . self visitObject: anElement shape.
		#color. self encodeColor: (anElement color).
		#id. (anElement shape validIdForView: anElement view).
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
RWJSONSerializeVisitor >> visitCamera: aCamera [
	^ Dictionary newFromPairs: {
		#id . aCamera validId.
		#type . #camera.
		#position . self encodeVector3: aCamera position.
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitConeShape: shape [
	^ #cone
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitCubeShape: aCubeShape [
	^ #cube
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitCylinderShape: aCubeShape [
	^ #cylinder
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitEdge: anElement [
	^ Dictionary newFromPairs: {
		#id . anElement validId.
		#type. #edge.
		#from_id . anElement from id. "isRWElement ifTrue: #validId ifFalse: nil."
		#from_position . self encodeVector3: anElement fromPosition.
		#to_id . anElement to id. "isRWElement ifTrue: #validId ifFalse: nil."
		#to_position . self encodeVector3: anElement toPosition.
		#color . self encodeVector4: anElement colorUsedForRendering.
		#shape . self encodeElementShape: anElement .
		#interactions . self encodeElementInteractions: anElement
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitElement: anElement [
	^ Dictionary newFromPairs: {
		#id . anElement validId.
		#type . #element.
		#position . self encodeVector3: anElement position.
		#color . self encodeVector4: anElement colorUsedForRendering.
		#shape . self encodeElementShape: anElement.
		#interactions . self encodeElementInteractions: anElement
	}
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitLineShape: aCubeShape [
	^ #line
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitMenuActivableInteraction: interaction [
	^ #menuActivable
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitMeshShape: shape [
	^ #meshShape
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitNullShape: aCubeShape [
	^ nil
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitPopupInteraction: interaction [
	^ #popup
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitPyramidShape: shape [
	^ #pyramid
]

{ #category : #visiting }
RWJSONSerializeVisitor >> visitUVSphereShape: shape [
	^ #uvSphere
]
