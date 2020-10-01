Class {
	#name : #RWForwardMovement,
	#superclass : #RWElementBehavior,
	#instVars : [
		'angle',
		'angularVelocity',
		'velocity',
		'acceleration',
		'angularSpeed',
		'speed'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWForwardMovement >> acceleration [
	^ acceleration
]

{ #category : #accessing }
RWForwardMovement >> acceleration: anObject [
	acceleration := anObject
]

{ #category : #accessing }
RWForwardMovement >> angle [
	^ angle
]

{ #category : #accessing }
RWForwardMovement >> angle: anObject [
	angle := anObject
]

{ #category : #accessing }
RWForwardMovement >> angularSpeed [
	^ angularSpeed
]

{ #category : #accessing }
RWForwardMovement >> angularSpeed: anObject [
	angularSpeed := anObject
]

{ #category : #accessing }
RWForwardMovement >> angularVelocity [
	^ angularVelocity
]

{ #category : #accessing }
RWForwardMovement >> angularVelocity: anObject [
	angularVelocity := anObject
]

{ #category : #initialization }
RWForwardMovement >> initialize [
	velocity := Float32x3 new.
	acceleration := Float32x3 new.
	angle := Float32x3 new.
	speed := 1.0.
	angularVelocity := Float32x3 new.
	angularSpeed := 0.5.
]

{ #category : #'time simulation' }
RWForwardMovement >> simulateTime: delta onElement: anElement [
	| orientation |
	(self isEnabledFor: anElement) ifFalse: [ ^ self ].
	angle := angle + (angularVelocity*(delta*angularSpeed)).
	orientation := (Float32x3x3 yRotation: angle y) * (Float32x3x3 xRotation: angle x).
	anElement
		orientation: orientation;
		translateBy: (orientation * (velocity*(delta*speed))).
	velocity := velocity + (acceleration*delta).
]

{ #category : #accessing }
RWForwardMovement >> speed [
	^ speed
]

{ #category : #accessing }
RWForwardMovement >> speed: anObject [
	speed := anObject
]

{ #category : #accessing }
RWForwardMovement >> velocity [
	^ velocity
]

{ #category : #accessing }
RWForwardMovement >> velocity: anObject [
	velocity := anObject
]
