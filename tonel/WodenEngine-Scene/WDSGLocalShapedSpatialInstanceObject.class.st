"
I am local spatial object that contains a logical separate shape transform.
"
Class {
	#name : #WDSGLocalShapedSpatialInstanceObject,
	#superclass : #WDSGLocalSpatialInstanceObject,
	#instVars : [
		'shapeTransform'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGLocalShapedSpatialInstanceObject >> computeGlobalTransform [
	^ super computeGlobalTransform transformTransform: shapeTransform.
]

{ #category : #initialization }
WDSGLocalShapedSpatialInstanceObject >> initialize [
	super initialize.
	shapeTransform := WMReversibleAffineTransformF identity.
]

{ #category : #accessing }
WDSGLocalShapedSpatialInstanceObject >> shapeTransform [
	^ shapeTransform
]

{ #category : #accessing }
WDSGLocalShapedSpatialInstanceObject >> shapeTransform: anObject [
	shapeTransform := anObject.
	self transformChanged
]
