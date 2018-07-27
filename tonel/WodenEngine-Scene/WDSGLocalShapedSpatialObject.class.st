"
I am local spatial object that contains a logical separate shape transform.
"
Class {
	#name : #WDSGLocalShapedSpatialObject,
	#superclass : #WDSGLocalSpatialObject,
	#instVars : [
		'shapeTransform'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #initialization }
WDSGLocalShapedSpatialObject >> initialize [
	super initialize.
	shapeTransform := WMReversibleAffineTransformF identity.
]

{ #category : #accessing }
WDSGLocalShapedSpatialObject >> shapeTransform [
	^ shapeTransform
]

{ #category : #accessing }
WDSGLocalShapedSpatialObject >> shapeTransform: anObject [
	shapeTransform := anObject
]

{ #category : #accessing }
WDSGLocalShapedSpatialObject >> updateRenderTransform [
	renderTransform := transform transformTransform: shapeTransform.
]
