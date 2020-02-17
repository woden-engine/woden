Class {
	#name : #RWOrbitMovement,
	#superclass : #RWElementBehavior,
	#instVars : [
		'phi',
		'r',
		'theta',
		'speedr',
		'accelerationr',
		'speedp',
		'accelerationp',
		'center'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #updating }
RWOrbitMovement >> applyPositionToElement: anElement [
	|x y z rotation disp |
	(self isEnabledFor: anElement) ifFalse: [ ^ self ].
	
	z := r * (theta cos) * (phi sin).
	x := r * (theta sin) * (phi sin).
	y := r * (phi cos).
	
	rotation := (WMMatrix3F yrot: theta) * (WMMatrix3F xrot: (phi -((Float pi)/2.0))).
	disp := (WMVector3F x: x y: y z: z).
	"disp := rotation transformVector: disp."
	
	anElement
		orientation: rotation;
		position: (disp + center)
	"camera distance: r."
]

{ #category : #defaults }
RWOrbitMovement >> back [
	theta := Float pi.
	phi := (Float pi)/2.0.
]

{ #category : #defaults }
RWOrbitMovement >> bottom [
	theta := 3.0 * (Float pi)/2.0.
	phi := (Float pi).
]

{ #category : #updating }
RWOrbitMovement >> center: aCentre [
	center := aCentre
]

{ #category : #updating }
RWOrbitMovement >> centre [
	^center
]

{ #category : #updating }
RWOrbitMovement >> deltaPhi: anAngle [
	phi := phi + anAngle.
]

{ #category : #updating }
RWOrbitMovement >> deltaTheta: anAngle [
	theta := theta + anAngle
]

{ #category : #defaults }
RWOrbitMovement >> front [
	theta := 0.0.
	phi := (Float pi)/2.0.
]

{ #category : #initialization }
RWOrbitMovement >> initialize [
	theta := 0.
	phi := 0.
	r := 1.
	speedr := 0.
	accelerationr := 0.
	
	speedp := WMVector3D zero.
	accelerationp := WMVector3D zero.
	
	super initialize.
]

{ #category : #defaults }
RWOrbitMovement >> left [
	theta := (Float pi)/2.0.
	phi := (Float pi)/2.0.
]

{ #category : #updating }
RWOrbitMovement >> phi [ 
	^phi
]

{ #category : #updating }
RWOrbitMovement >> phi: anAngle [
	phi := anAngle
]

{ #category : #updating }
RWOrbitMovement >> r [
	^r
]

{ #category : #updating }
RWOrbitMovement >> r: aRadius [
	r := aRadius
]

{ #category : #defaults }
RWOrbitMovement >> right [
	theta := (Float pi)/2.0 negated.
	phi := (Float pi)/2.0.
]

{ #category : #updating }
RWOrbitMovement >> setPhi: aPhi theta: aTheta r: aRadius [
	phi:=aPhi.
	theta:=aTheta.
	r:=aRadius.
]

{ #category : #'time simulation' }
RWOrbitMovement >> simulateTime: delta onElement: anElement [
	self applyPositionToElement: anElement
]

{ #category : #updating }
RWOrbitMovement >> stopr [
	speedr := 0.0.
	accelerationr := 0.0
]

{ #category : #updating }
RWOrbitMovement >> stopx [
	speedp x: 0.0.
	accelerationp x: 0.0.
]

{ #category : #updating }
RWOrbitMovement >> stopy [
	speedp y: 0.0.
	accelerationp y: 0.0.
]

{ #category : #updating }
RWOrbitMovement >> stopz [
	speedp z: 0.0.
	accelerationp z: 0.0.
]

{ #category : #updating }
RWOrbitMovement >> theta [
	^theta
]

{ #category : #updating }
RWOrbitMovement >> theta: anAngle [
	theta := anAngle
]

{ #category : #defaults }
RWOrbitMovement >> top [
	theta := 3.0 * (Float pi)/2.0 negated.
	phi := 2.0 * (Float pi).
]

{ #category : #updating }
RWOrbitMovement >> updateAccelerationp: update [
	accelerationp := accelerationp + update.
]

{ #category : #updating }
RWOrbitMovement >> updateAccelerationr: update [
	accelerationr := accelerationr + update.
]
