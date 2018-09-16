Class {
	#name : #WDPhyCharacterController,
	#superclass : #WDPhyObject,
	#instVars : [
		'ghostObject',
		'shape',
		'stepHeight',
		'upAxis',
		'maxJumpHeight',
		'linearVelocity',
		'gravity',
		'jumpSpeed'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #actions }
WDPhyCharacterController >> canJump [
	^ physicsEngine ifNil: [ false ] ifNotNil: [ physicsEngine canCharacterJump: self ]
]

{ #category : #accessing }
WDPhyCharacterController >> computeJumpSpeed [
	"jumpSpeed := (gravity negated * maxJumpHeight) sqrt"
	jumpSpeed := (gravity * maxJumpHeight) abs sqrt
]

{ #category : #accessing }
WDPhyCharacterController >> ghostObject [
	^ ghostObject
]

{ #category : #accessing }
WDPhyCharacterController >> ghostObject: anObject [
	ghostObject := anObject
]

{ #category : #accessing }
WDPhyCharacterController >> gravity [
	^ gravity
]

{ #category : #accessing }
WDPhyCharacterController >> gravity: newGravity [
	gravity := newGravity.
	self computeJumpSpeed.
	physicsEngine ifNotNil: [
		physicsEngine characterController: self setGravity: gravity jumpSpeed: jumpSpeed
	].

]

{ #category : #initialization }
WDPhyCharacterController >> initialize [
	super initialize.
	upAxis := #y.
	stepHeight := 0.20.
	maxJumpHeight := 0.6.
	gravity := -9.8.
	linearVelocity := WMVector3F zero.
	self computeJumpSpeed.
]

{ #category : #actions }
WDPhyCharacterController >> jump [
	^ physicsEngine ifNotNil: [ physicsEngine characterJump: self ]
]

{ #category : #accessing }
WDPhyCharacterController >> jumpSpeed [
	^ jumpSpeed
]

{ #category : #accessing }
WDPhyCharacterController >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WDPhyCharacterController >> linearVelocity: velocity [
	linearVelocity := velocity.
	^ physicsEngine ifNotNil: [ physicsEngine characterController: self setLinearVelocity: velocity ]
]

{ #category : #accessing }
WDPhyCharacterController >> maxJumpHeight [
	^ maxJumpHeight
]

{ #category : #accessing }
WDPhyCharacterController >> maxJumpHeight: anObject [
	maxJumpHeight := anObject.
	self computeJumpSpeed.
]

{ #category : #accessing }
WDPhyCharacterController >> position [
	^ ghostObject position
]

{ #category : #accessing }
WDPhyCharacterController >> shape [
	^ shape
]

{ #category : #accessing }
WDPhyCharacterController >> shape: anObject [
	shape := anObject
]

{ #category : #accessing }
WDPhyCharacterController >> stepHeight [
	^ stepHeight
]

{ #category : #accessing }
WDPhyCharacterController >> stepHeight: anObject [
	stepHeight := anObject
]

{ #category : #accessing }
WDPhyCharacterController >> upAxis [
	^ upAxis
]

{ #category : #accessing }
WDPhyCharacterController >> upAxis: anObject [
	upAxis := anObject
]
