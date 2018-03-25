Class {
	#name : #WTAthensSimplePathBuilder,
	#superclass : #AthensSimplePathBuilder,
	#category : 'Woden2-Athens'
}

{ #category : #'builder commands' }
WTAthensSimplePathBuilder >> closePath [
	self close
]

{ #category : #'builder commands' }
WTAthensSimplePathBuilder >> hLineTo: x [
	absolute
		ifTrue: [ self lineToX: x Y: lastSegment endPoint y ]
		ifFalse: [ self lineToX: x Y: 0 ]
]

{ #category : #'builder commands' }
WTAthensSimplePathBuilder >> lineToX: x Y: y [
	^ self lineTo: x@y
]

{ #category : #'path commands' }
WTAthensSimplePathBuilder >> string: aString font: aFont [
	self addSegment: (WTAthensTextSegment new string: aString; font: aFont; endPoint: lastSegment endPoint)
]

{ #category : #'builder commands' }
WTAthensSimplePathBuilder >> vLineTo: y [
	absolute
		ifTrue: [ self lineToX: lastSegment endPoint x Y: y ]
		ifFalse: [ self lineToX: 0 Y: y ]
]
