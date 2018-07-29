"
I am an iterator for the triangles present in a set of submeshes.
"
Class {
	#name : #WDCSubmeshTriangleIterator,
	#superclass : #Object,
	#instVars : [
		'indices',
		'submeshes'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCSubmeshTriangleIterator class >> indices: indices submeshes: submeshes [
	^ self new
		indices: indices;
		submeshes: submeshes;
		yourself
]

{ #category : #enumerating }
WDCSubmeshTriangleIterator >> do: aBlock [
	submeshes do: [ :submesh |
		self iterateSubmesh: submesh with: aBlock
	].
]

{ #category : #accessing }
WDCSubmeshTriangleIterator >> indices [
	^ indices
]

{ #category : #accessing }
WDCSubmeshTriangleIterator >> indices: anObject [
	indices := anObject
]

{ #category : #enumerating }
WDCSubmeshTriangleIterator >> iterateSubmesh: submesh with: aBlock [
	| triangleCount nextIndex i1 i2 i3 |
	submesh primitiveType ~= AGPU_TRIANGLES ifTrue: [ ^ self ].
	
	triangleCount := submesh indexCount // 3.
	nextIndex := submesh firstIndex + 1.
	1 to: triangleCount do: [ :t |
		i1 := indices at: nextIndex.
		i2 := indices at: nextIndex + 1.
		i3 := indices at: nextIndex + 2.
		aBlock value: { i1 . i2 . i3 }.
		
		nextIndex := nextIndex + 3
	]
]

{ #category : #accessing }
WDCSubmeshTriangleIterator >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDCSubmeshTriangleIterator >> submeshes: anObject [
	submeshes := anObject
]
