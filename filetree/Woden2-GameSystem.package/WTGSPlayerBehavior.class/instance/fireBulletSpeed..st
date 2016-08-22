as yet unclassified
fireBulletSpeed: initialSpeed
	| initialVelocity initialPosition node bullet |
	headTransform ifNil: [ ^ self ].
	initialVelocity := headTransform transformVector3: (WMVector3F z: initialSpeed negated).
	initialPosition := headTransform translation.

	node := WTSLocalSpatialObject new.
	node transform translation: initialPosition.
	bulletsNode addChild: node.
		
	bullet := WTGSBullet new
		position: initialPosition asWMVector3D;
		velocity: initialVelocity asWMVector3D;
		node: node.
	bullets add: bullet.
	