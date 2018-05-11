Class {
	#name : #RWShapeBuilder,
	#superclass : #RWObject,
	#instVars : [
		'shape',
		'createdElements',
		'shapeInitializer'
	],
	#category : 'WodenEngine-Roassal-Builder'
}

{ #category : #accessing }
RWShapeBuilder >> box [
	^ self cube
]

{ #category : #accessing }
RWShapeBuilder >> color [
	^ self current color
]

{ #category : #accessing }
RWShapeBuilder >> createdElements [
	^ createdElements
]

{ #category : #accessing }
RWShapeBuilder >> cube [
	self shape: RWCube new
]

{ #category : #accessing }
RWShapeBuilder >> current [
	"Return the shape currently built"
	^ shape
]

{ #category : #'reflective operations' }
RWShapeBuilder >> doesNotUnderstand: aMessage [
	"we simply forward the messages we do not understand
	to the actual shape implementation"
	self shape 
		perform: aMessage selector 
		withArguments: aMessage arguments
]

{ #category : #public }
RWShapeBuilder >> elementOn: object [
	^ (self elementsOn: (RWGroup with: object)) first
]

{ #category : #public }
RWShapeBuilder >> elementsOn: objects [
	| answer |
	self hasSetShape ifFalse: [ self rectangle ].
	answer := shape elementsOn: objects.
	createdElements addAll: answer.
	^ answer
]

{ #category : #exceptions }
RWShapeBuilder >> ensure: aClassShape [
	"Make sure the current shape is instance of aClassShapeName. If no, then set it"
	(shape isKindOf: aClassShape)
		ifFalse: [ self shape: aClassShape new ]
]

{ #category : #accessing }
RWShapeBuilder >> fillColor [
	^ self color
]

{ #category : #testing }
RWShapeBuilder >> hasSetShape [
	^ shape notNil
	"In roassal:
	^ shape class ~~ RTNoShape"
]

{ #category : #coloring }
RWShapeBuilder >> if: conditionBlock color: colorBlock [
	| oldBlockOrValue |
	oldBlockOrValue := self color.
	^self color: [ :aModel | (conditionBlock rwValue: aModel)
									ifTrue: [ colorBlock rwValue: aModel ] 
									ifFalse: [ 
										oldBlockOrValue rwValue: (RWElement on: aModel) ]].
							
						
]

{ #category : #shapes }
RWShapeBuilder >> if: conditionBlock fillColor: colorBlock [
	"If conditionBlock is evaluated at true, then colorBlock is used to set the color of the node. Both conditionBlock and colorBlock are evaluated with the model value of the node."
	| oldBlockOrValue |
	oldBlockOrValue := self fillColor.
	self fillColor: [ :aModel | (conditionBlock rwValue: aModel)
									ifTrue: [ colorBlock rwValue: aModel ] 
									ifFalse: [ 
										"Having to create a new element is rather ugly. 
										Ideally, the oldBlockOrValue has to be 'unwrapped' for the translation"
										oldBlockOrValue rwValue: (RWElement on: aModel) ]].
							
						

]

{ #category : #shapes }
RWShapeBuilder >> ifElement: conditionBlock fillColor: colorBlock [
	"If conditionBlock is evaluated at true, then colorBlock is used to set the color of the node. Both conditionBlock and colorBlock are evaluated with the model value of the node."
	| oldBlockOrValue |
	oldBlockOrValue := self fillColor.
	^self fillColorElement: [ :anElement | (conditionBlock rwValue: anElement)
									ifTrue: [ colorBlock rwValue: anElement ] 
									ifFalse: [ 
										"Having to create a new element is rather ugly. 
										Ideally, the oldBlockOrValue has to be 'unwrapped' for the translation"
										oldBlockOrValue rwValue: anElement ]].
							
						

]

{ #category : #initialization }
RWShapeBuilder >> initialize [
	super initialize.
	self reset.
 	shapeInitializer := #yourself
]

{ #category : #accessing }
RWShapeBuilder >> rectangle [
	^ self cube
]

{ #category : #accessing }
RWShapeBuilder >> reset [
	self resetShape.
	self resetCreatedElements
]

{ #category : #protected }
RWShapeBuilder >> resetCreatedElements [
	createdElements := OrderedCollection new
]

{ #category : #accessing }
RWShapeBuilder >> resetShape [
	shape := RWCube new
]

{ #category : #'public - building' }
RWShapeBuilder >> setUpElement: anElement [
	self hasSetShape ifFalse: [ self box ].
	^ anElement shape: shape
]

{ #category : #building }
RWShapeBuilder >> setUpElements: elements [
	self hasSetShape ifFalse: [ self box ].
	^ elements do: [ :e | e shape: shape ]
]

{ #category : #accessing }
RWShapeBuilder >> shape [
	"Return the shape currently built"
	^ shape
]

{ #category : #accessing }
RWShapeBuilder >> shape: aRoassalShape [
	shape := aRoassalShape.
	shapeInitializer rwValue: shape.
	^ aRoassalShape
]

{ #category : #accessing }
RWShapeBuilder >> shapeInitializer: aBlock [
	"Invoked after a shape has been designed"
	shapeInitializer := aBlock
]
