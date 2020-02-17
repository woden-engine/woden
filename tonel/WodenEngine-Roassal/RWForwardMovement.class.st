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
	velocity := WMVector3F new.
	acceleration := WMVector3F new.
	angle := WMVector3F new.
	speed := 1.0.
	angularVelocity := WMVector3F new.
	angularSpeed := 0.5.
]

{ #category : #'time simulation' }
RWForwardMovement >> simulateTime: delta onElement: anElement [
	| orientation |
	(self isEnabledFor: anElement) ifFalse: [ ^ self ].
	angle := angle + (angularVelocity*(delta*angularSpeed)).
	orientation := (WMMatrix3F yrot: angle y) * (WMMatrix3F xrot: angle x).
	anElement
		orientation: orientation;
		translateBy: (orientation transformVector3: (velocity*(delta*speed))).
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
