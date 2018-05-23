Class {
	#name : #RWOrbitMovement,
	#superclass : #Object,
	#instVars : [
		'camera',
		'centre',
		'phi',
		'r',
		'theta',
		'speedr',
		'accelerationr',
		'speedp',
		'accelerationp'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #defaults }
RWOrbitMovement >> back [
	theta := Float pi.
	phi := (Float pi)/2.0.
	
	self updatePosition.
]

{ #category : #defaults }
RWOrbitMovement >> bottom [
	theta := 3.0 * (Float pi)/2.0.
	phi := (Float pi).
	
	self updatePosition.
]

{ #category : #updating }
RWOrbitMovement >> camera [ 
	^camera
]

{ #category : #updating }
RWOrbitMovement >> camera: aCamera [
	camera := aCamera
]

{ #category : #updating }
RWOrbitMovement >> centre [
	^centre
]

{ #category : #updating }
RWOrbitMovement >> centre: aCentre [
	centre := aCentre
]

{ #category : #defaults }
RWOrbitMovement >> front [
	theta := 0.0.
	phi := (Float pi)/2.0.
	
	self updatePosition.
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
	
	self updatePosition.
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
	
	self updatePosition.
]

{ #category : #updating }
RWOrbitMovement >> setPhi: aPhi theta: aTheta r: aRadius [
	phi:=aPhi.
	theta:=aTheta.
	r:=aRadius.
	
	self updatePosition
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
	
	self updatePosition.
]

{ #category : #updating }
RWOrbitMovement >> update: delta forNode: sceneNode [
	| rotation tmp |
	speedr := speedr + (accelerationr * 0.5 * delta).
	r := r + (speedr * delta).
	speedr := speedr + (accelerationr * 0.5 * delta).
	
	
	rotation := (WMMatrix3D yrot: theta) * (WMMatrix3D xrot: (phi -((Float pi)/2.0))).
	
	speedp := speedp + (accelerationp * 0.5 * delta).
	tmp := (speedp * delta).
	tmp := rotation transformVector: tmp.
	centre := centre + tmp.
	speedp := speedp + (accelerationp * 0.5 * delta).
	
	self updatePosition.
]

{ #category : #updating }
RWOrbitMovement >> updateAccelerationp: update [
	accelerationp := accelerationp + update.
]

{ #category : #updating }
RWOrbitMovement >> updateAccelerationr: update [
	accelerationr := accelerationr + update.
]

{ #category : #updating }
RWOrbitMovement >> updatePhi: anAngle [
	phi := phi + anAngle.
]

{ #category : #updating }
RWOrbitMovement >> updatePosition [
	|x y z rotation disp |
	
	z := r * (theta cos) * (phi sin).
	x := r * (theta sin) * (phi sin).
	y := r * (phi cos).
	
	rotation := (WMMatrix3D yrot: theta) * (WMMatrix3D xrot: (phi -((Float pi)/2.0))).
	disp := (WMVector3D x: x y: y z: z).
	"disp := rotation transformVector: disp."
	
	camera position: (disp + centre).
	camera orientation: rotation.
	camera distance: r.
]

{ #category : #updating }
RWOrbitMovement >> updateTheta: anAngle [
	theta := theta + anAngle
]
