Class {
	#name : #WDGSPlayerBehavior,
	#superclass : #WDGSPhysicsCharacterControllerBehavior,
	#instVars : [
		'speed',
		'weapons',
		'currentWeapon',
		'weaponSceneNode',
		'weaponAction',
		'weaponActionFrame',
		'weaponActionRepeated',
		'velocityDirection',
		'weaponAnimationSpeed',
		'soundListener',
		'weaponSoundSource',
		'bullets',
		'bulletsNode',
		'headTransform'
	],
	#category : #'WodenEngine-OldGameSystem-Player'
}

{ #category : #'as yet unclassified' }
WDGSPlayerBehavior class >> analogDeadZone [
	^ 8000
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehavior class >> eyePosition [
	^ self halfExtent y - 0.1
]

{ #category : #accessing }
WDGSPlayerBehavior class >> halfExtent [
	^ Float64x3 x: 0.3 y: 0.9 z: 0.3
]

{ #category : #adding }
WDGSPlayerBehavior >> activateWeapon: aWeapon [
	| camera |
	currentWeapon := aWeapon.
	weaponSceneNode ifNotNil: [
		self flag: 'Try to avoid removing the old scene node.'.
		weaponSceneNode removeFromScene
	].

	camera := self cameraSceneNode.
	camera ifNotNil: [ 
		weaponSceneNode := WDSGSpatialObject new.
		currentWeapon precacheResourcesFor: self engine.
		weaponSceneNode renderable: (currentWeapon fpsModelFor: self engine).
		camera addChild: weaponSceneNode.
	].
 	
	self runWeaponAnimationAction: 'Draw'.
]

{ #category : #adding }
WDGSPlayerBehavior >> addAndActivateWeapon: aWeapon [
	weapons add: aWeapon.
	self activateWeapon: aWeapon.
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> axisMapping: value [
	| deadZone |
	deadZone := self class analogDeadZone.
	((value > deadZone negated) and: [ value < deadZone ]) ifTrue: [ ^ 0.0 ].
	^ value / 32768.0
]

{ #category : #'map events' }
WDGSPlayerBehavior >> createCollisionShape [
	collisionShape := WDPhyCapsuleYCollisionShape new halfExtent: self class halfExtent
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehavior >> fireBulletSpeed: initialSpeed [
	| initialVelocity initialPosition node bullet |
	headTransform ifNil: [ ^ self ].
	initialVelocity := headTransform transformVector3: (Float32x3 z: initialSpeed negated).
	initialPosition := headTransform translation.

	node := WDSGLocalSpatialInstanceObject new.
	node transform: (headTransform copy
		translation: initialPosition).
	bulletsNode addChild: node.
		
	bullet := WDGSBullet new
		position: initialPosition asFloat64x3;
		velocity: initialVelocity asFloat64x3;
		node: node.
	bullets add: bullet.
	
]

{ #category : #initialization }
WDGSPlayerBehavior >> initialize [
	super initialize.
	speed := 1.0.
	weapons := OrderedCollection new.
	weaponAnimationSpeed := 1.0.
	velocityDirection := Float64x3 new.
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> mapTrigger: value [
	| newValue |
	newValue := value / 32768.0.
	newValue < 0.2 ifTrue: [ ^ 0.0 ].
	^ newValue
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onJoyAxis: event [
	| value |
	event isPreferredEvent ifFalse: [ ^ self ].
	
	value := self axisMapping: event value.
	event isLeftX ifTrue: [ 
		velocityDirection x: value
	].

	event isLeftY ifTrue: [
		velocityDirection z: value
	].

	event isRightX ifTrue: [ 
		angularVelocity y: value negated
	].

	event isRightY ifTrue: [ 
		angularVelocity x: value negated
	].

	event isTriggerRight ifTrue: [
		speed := 1.0 + (2.0 * (self mapTrigger: event value))
	]

]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onJoyButtonDown: event [
	event isPreferredEvent ifFalse: [ ^ self ].
	event isButtonX ifTrue: [ 
		self shoot
	]
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onJoyButtonUp: event [
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onKeyDown: anEvent [
	| symbol |
	symbol := anEvent symbol.
	symbol = OSK_a ifTrue: [ velocityDirection x: -1.0 ].
	symbol = OSK_d ifTrue: [ velocityDirection x: 1.0 ].
	symbol = OSK_w ifTrue: [ velocityDirection z: -1.0 ].
	symbol = OSK_s ifTrue: [ velocityDirection z: 1.0 ].
	symbol = OSK_LCTRL ifTrue: [ self crouch ].
	symbol = OSK_SPACE ifTrue: [ self jump ].

	symbol = OSK_UP ifTrue: [ angularVelocity x: 1.0 ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x: -1.0 ].
	symbol = OSK_LEFT ifTrue: [ angularVelocity y: 1.0 ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y: -1.0 ].
	
	symbol = OSK_LSHIFT ifTrue: [ speed := 3.0 ].
	
	(anEvent modifiers leftAlt and: [ symbol = OSK_i ]) ifTrue: [ self inspect ].
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onKeyUp: anEvent [
	| symbol |
	symbol := anEvent symbol.
	symbol = OSK_a ifTrue: [ velocityDirection x < 0 ifTrue: [ velocityDirection x: 0.0 ] ].
	symbol = OSK_d ifTrue: [ velocityDirection x > 0 ifTrue: [ velocityDirection x: 0.0 ] ].
	symbol = OSK_w ifTrue: [ velocityDirection z < 0 ifTrue: [ velocityDirection z: 0.0 ] ].
	symbol = OSK_s ifTrue: [ velocityDirection z > 0 ifTrue: [ velocityDirection z: 0.0 ] ].

	symbol = OSK_UP ifTrue: [ angularVelocity x > 0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_DOWN ifTrue: [ angularVelocity x < 0 ifTrue: [ angularVelocity x: 0.0 ] ].
	symbol = OSK_LEFT ifTrue: [ angularVelocity y > 0 ifTrue: [ angularVelocity y: 0.0 ] ].
	symbol = OSK_RIGHT ifTrue: [ angularVelocity y < 0 ifTrue: [ angularVelocity y: 0.0 ] ].
	
	symbol = OSK_LCTRL ifTrue: [ velocityDirection y < 0 ifTrue: [ velocityDirection y: 0.0 ] ].
	symbol = OSK_SPACE ifTrue: [ velocityDirection y > 0 ifTrue: [ velocityDirection y: 0.0 ] ].
	symbol = OSK_LSHIFT ifTrue: [ speed := 1.0 ].
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onMouseButtonDown: event [
	event button = 1 ifTrue: [
		self shoot
	]
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onMouseButtonUp: anEvent [
]

{ #category : #'event handling' }
WDGSPlayerBehavior >> onMouseMove: event [
	| angleScale |
	angleScale := Float pi / 180.0 * 0.1.
	angle := angle + (Float64x3 x: event delta y * angleScale negated y: event delta x * angleScale  negated z: 0.0)
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehavior >> pickItem: anItem [
	anItem activateOnPlayer: self
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehavior >> playRandomShootSound: sounds [
	(sounds isNil or: [ sounds isEmpty ]) ifTrue: [ ^ self ].
	self playShootSound: sounds atRandom
]

{ #category : #'as yet unclassified' }
WDGSPlayerBehavior >> playShootSound: sound [
	sound ifNil: [ ^ self ].
	weaponSoundSource dataSource: sound; play
]

{ #category : #'weapon animation' }
WDGSPlayerBehavior >> runRepeatedWeaponAnimation: actionName [
	self runRepeatedWeaponAnimation: actionName speed: 1.0
]

{ #category : #'weapon animation' }
WDGSPlayerBehavior >> runRepeatedWeaponAnimation: actionName speed: animationSpeed [
	| animationState |
	animationState := weaponSceneNode renderableSceneData.
	weaponAction := animationState actionNamed: actionName.
	weaponActionFrame := 0.0.
	weaponActionRepeated := true.
	weaponAnimationSpeed := animationSpeed.
]

{ #category : #'weapon animation' }
WDGSPlayerBehavior >> runWeaponAnimationAction: actionName [
	self runWeaponAnimationAction: actionName speed: 1.0 doAfter: nil
]

{ #category : #'weapon animation' }
WDGSPlayerBehavior >> runWeaponAnimationAction: actionName doAfter: finishBlock [
	self runWeaponAnimationAction: actionName speed: 1.0 doAfter: finishBlock
]

{ #category : #'weapon animation' }
WDGSPlayerBehavior >> runWeaponAnimationAction: actionName speed: animationSpeed [
	self runWeaponAnimationAction: actionName speed: animationSpeed doAfter: nil
]

{ #category : #'weapon animation' }
WDGSPlayerBehavior >> runWeaponAnimationAction: actionName speed: animationSpeed doAfter: finishBlock [
	| animationState |
	animationState := weaponSceneNode renderableSceneData.
	weaponAction := animationState actionNamed: actionName.
	weaponActionFrame := 0.0.
	weaponActionRepeated := false.
	weaponAnimationSpeed := animationSpeed.
]

{ #category : #'game controls' }
WDGSPlayerBehavior >> shoot [
	currentWeapon ifNotNil: [ currentWeapon shootWithPlayer: self ]
]

{ #category : #'map events' }
WDGSPlayerBehavior >> simulateTime: delta [
	| spatialDesc transform camera orientation |
	linearVelocity := velocityDirection * speed.
	super simulateTime: delta.
	spatialDesc := entity spatialDescription.
	transform := spatialDesc transform.
	
	camera := self cameraSceneNode.
	camera ifNotNil: [
		orientation := (Float32x3x3 yrot: angle y) * (Float32x3x3 xrot: angle x).
		
		camera transform
			orthonormal: orientation;
			translation: transform translation asFloat32x3;
			translateByY: self class eyePosition.
		headTransform := camera transform copy
	].

	soundListener ifNotNil: [ 
		soundListener
			position: transform translation asFloat32x3;
			velocity: linearVelocity asFloat32x3;
			orientation: transform matrix asFloat32x3x3.
	].

	weaponAction ifNotNil: [
		weaponActionFrame := weaponActionFrame + (delta *30.0 * weaponAnimationSpeed).
		weaponSceneNode renderableSceneData
			setRestPose;
			addAction: weaponAction repeated: weaponActionRepeated frame: weaponActionFrame;
			computePoseMatrices.
			
		(weaponActionRepeated not and: [ weaponActionFrame > weaponAction numberOfFrames ]) ifTrue: [
			self runRepeatedWeaponAnimation: 'Idle' 
		]
	].

	bullets do: [ :bullet | bullet update: delta ]
]

{ #category : #'map events' }
WDGSPlayerBehavior >> spawn [
	super spawn.

	soundListener := self engine createSoundListener.
	soundListener activate.
	
	weaponSoundSource := self engine createSoundSource.
	bullets := OrderedCollection new.
	bulletsNode := WDSGSpatialObjectInstanceGroup new.
	bulletsNode updatedPerFrame: false.
	bulletsNode renderable: ((WDCComplexGenericMeshBuilder for: self engine)
		rotateRadiansOnX: Float halfPi;
		addCylinderRadius: 0.0254*0.357*0.5 height: 0.03 segments: 2 slices: 6;
		mesh).
	self scene add: bulletsNode.
		
	self setBoundingBox: (Box3D halfExtent: self class halfExtent).
	self view ifNotNil: [ :view | view playerEventHandler: (WDGSPlayerBehaviorEventHandler new behavior: self)].
	self subscribeToTouchEvents.

]
