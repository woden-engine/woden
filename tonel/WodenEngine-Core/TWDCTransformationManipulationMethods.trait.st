Trait {
	#name : #TWDCTransformationManipulationMethods,
	#category : #'WodenEngine-Core-Utility'
}

{ #category : #accessing }
TWDCTransformationManipulationMethods >> position [
	self explicitRequirement
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateBy: translation [
	self translateTo: self position + translation
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateByX: translation [
	self translateBy: (Float32x3 x: translation)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateByX: x y: y z: z [
	self translateBy: (Float32x3 x: x y: y z: z)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateByY: translation [
	self translateBy: (Float32x3 y: translation)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateByZ: translation [
	self translateBy: (Float32x3 new z: translation)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateTo: translation [
	self explicitRequirement
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateToX: newX [
	self translateTo: (self position x: newX)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateToX: newX y: newY z: newZ [ 
	self translateTo: (Float32x3 x: newX y: newY z: newZ)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateToY: newY [
	self translateTo: (self position y: newY)
]

{ #category : #transforming }
TWDCTransformationManipulationMethods >> translateToZ: newZ [
	self translateTo: (self position z: newZ)
]
