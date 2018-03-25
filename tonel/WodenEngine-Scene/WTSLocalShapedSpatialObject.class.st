"
I am local spatial object that contains a logical separate shape transform.
"
Class {
	#name : #WTSLocalShapedSpatialObject,
	#superclass : #WTSLocalSpatialObject,
	#instVars : [
		'shapeTransform'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #initialization }
WTSLocalShapedSpatialObject >> initialize [
	super initialize.
	shapeTransform := WMReversibleAffineTransformF identity.
]

{ #category : #accessing }
WTSLocalShapedSpatialObject >> shapeTransform [
	^ shapeTransform
]

{ #category : #accessing }
WTSLocalShapedSpatialObject >> shapeTransform: anObject [
	shapeTransform := anObject
]

{ #category : #accessing }
WTSLocalShapedSpatialObject >> updateRenderTransform [
	renderTransform := transform transformTransform: shapeTransform.
]
