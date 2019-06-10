Class {
	#name : #WDCVertexBindingConstants,
	#superclass : #SharedPool,
	#classVars : [
		'NormalsVertexBindingLocation',
		'PositionsVertexBindingLocation',
		'Tangents4VertexBindingLocation',
		'TexcoordsVertexBindingLocation'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'class initialization' }
WDCVertexBindingConstants class >> initialize [
	PositionsVertexBindingLocation := 0.
	TexcoordsVertexBindingLocation := 1.
	NormalsVertexBindingLocation := 3.
	Tangents4VertexBindingLocation := 4.

]
