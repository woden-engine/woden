Class {
	#name : #WTGSWeapon,
	#superclass : #Object,
	#instVars : [
		'fpsModel',
		'shootSounds'
	],
	#category : 'WodenEngine-GameSystem-Item'
}

{ #category : #'as yet unclassified' }
WTGSWeapon >> fpsModelFor: anEngine [
	fpsModel ifNil: [
		fpsModel := anEngine resourceCache loadMesh: self fpsModelName
	].
	^ fpsModel
]

{ #category : #'as yet unclassified' }
WTGSWeapon >> fpsModelName [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WTGSWeapon >> precacheResourcesFor: engine [
	self
		fpsModelFor: engine;
		shootSoundsFor: engine.
]

{ #category : #'as yet unclassified' }
WTGSWeapon >> setFPSModelIn: sceneNode [
	fpsModel ifNil: [
		fpsModel := sceneNode engine resourceCache loadMesh: self fpsModelName
	].
	sceneNode renderable: fpsModel
]

{ #category : #'as yet unclassified' }
WTGSWeapon >> shootSoundNames [
	^ #()
]

{ #category : #accessing }
WTGSWeapon >> shootSoundsFor: anEngine [
	shootSounds ifNil: [
		shootSounds := self shootSoundNames collect: [:name | anEngine resourceCache loadSoundSample: name ]
	].
	^ shootSounds
]

{ #category : #'as yet unclassified' }
WTGSWeapon >> shootWithPlayer: player [
	player playRandomShootSound: shootSounds.
	player runWeaponAnimationAction: 'Shoot' speed: 4.5 doAfter: [
		player runRepeatedWeaponAnimation: 'Idle'
	].

	player fireBulletSpeed: 30.0 
]
