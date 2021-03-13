Class {
	#name : #RWOrbitController,
	#superclass : #RWViewInteraction,
	#instVars : [
		'camera',
		'orbitMovement',
		'center'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #'event handling' }
RWOrbitController >> axisMapping: value [
	| deadZone |
	deadZone := self class analogDeadZone.
	((value > deadZone negated) and: [ value < deadZone ]) ifTrue: [ ^ 0.0 ].
	^ value / 32768.0
]

{ #category : #defaults }
RWOrbitController >> back [
	orbitMovement back
]

{ #category : #defaults }
RWOrbitController >> bottom [
	orbitMovement bottom
]

{ #category : #accessing }
RWOrbitController >> camera [
	^ camera
]

{ #category : #accessing }
RWOrbitController >> center: aPoint [
	center := aPoint.
	
	orbitMovement center: aPoint
]

{ #category : #defaults }
RWOrbitController >> front [
	orbitMovement front
]

{ #category : #hooks }
RWOrbitController >> initializeElement: aView [
	| r boundingBox |
	camera := aView camera.
	orbitMovement := RWOrbitMovement new
		enabledWhen: [aView isInVirtualReality not];
		yourself.
	camera addBehavior: orbitMovement.
	
	boundingBox := aView boundingBox.
	orbitMovement center: boundingBox center.
	
	orbitMovement theta: 0.0.
	orbitMovement phi: (Float pi)/2.0.
	
	r := (boundingBox width max: boundingBox height) max: boundingBox depth.
	r := r * 1.7.
	orbitMovement r: r.

	aView when: RWKeyDown do: [ :evt |
		self onKeyDown: evt.
	].
	aView when: RWKeyUp do: [ :evt |
		self onKeyUp: evt.
	].
	aView when: RWMouseDrag do: [ :evt |
		evt isLeftButton ifTrue: [ self onMouseDrag: evt ].
	].
	aView when: RWMouseWheel do: [ :evt |
		self onMouseWheel: evt
	].

]

{ #category : #defaults }
RWOrbitController >> left [
	orbitMovement left
]

{ #category : #'event handling' }
RWOrbitController >> mapTrigger: value [
	| newValue |
	newValue := (value / 32768.0)*0.5 + 0.5.
	newValue < 0.2 ifTrue: [ ^ 0.0 ].
	^ newValue
]

{ #category : #'event handling' }
RWOrbitController >> mapTriggerHard: value [
	^ (self mapTrigger: value) > 0.5 ifTrue: [ 1.0 ] ifFalse: [ 0.0 ].
]

{ #category : #'event handling' }
RWOrbitController >> onKeyDown: event [
	| symbol step accp |
	step := 100.0.
	symbol := event symbol.

	symbol == OSK_w ifTrue: [ orbitMovement updateAccelerationr: step negated].
	symbol == OSK_s ifTrue: [ orbitMovement updateAccelerationr: step ].

	accp := Float64x3 zeros.
	
	symbol == OSK_a ifTrue: [ accp x: (step negated)].
	symbol == OSK_d ifTrue: [ accp x: step ].	
		
	symbol == OSK_e ifTrue: [ accp y: (step negated)].
	symbol == OSK_q ifTrue: [ accp y: step ].	
	
	symbol == OSK_r ifTrue: [ accp z: (step negated)].
	symbol == OSK_f ifTrue: [ accp z: step ].		

	orbitMovement updateAccelerationp: accp.
]

{ #category : #'event handling' }
RWOrbitController >> onKeyUp: event [
	| symbol |
	
	symbol := event symbol.
	
	(symbol == OSK_w) | (symbol == OSK_s) ifTrue: [ orbitMovement stopr].
	
	(symbol == OSK_a) | (symbol == OSK_d) ifTrue: [ orbitMovement stopx].
	(symbol == OSK_q) | (symbol == OSK_e) ifTrue: [ orbitMovement stopy].
	(symbol == OSK_r) | (symbol == OSK_f) ifTrue: [ orbitMovement stopz].
	
]

{ #category : #'event handling' }
RWOrbitController >> onMouseDrag: event [
	self camera isPerspective: true.
	"self recentreCamera."
	
	orbitMovement
		deltaPhi: ((event delta y)/100.0) negated;
		deltaTheta: ((event delta x)/100.0) negated
]

{ #category : #'event handling' }
RWOrbitController >> onMouseWheel: event [
	
	orbitMovement
		deltaR: orbitMovement r * (event scrollVertical negated / 10)
]

{ #category : #accessing }
RWOrbitController >> orbitMovement [
	^orbitMovement
]

{ #category : #defaults }
RWOrbitController >> right [
	orbitMovement right
]

{ #category : #accessing }
RWOrbitController >> setPhi: aPhi theta: aTheta r: aRadius [
	orbitMovement setPhi: aPhi theta: aTheta r: aRadius
]

{ #category : #defaults }
RWOrbitController >> top [
	orbitMovement top
]
