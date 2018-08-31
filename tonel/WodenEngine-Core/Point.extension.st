Extension { #name : #Point }

{ #category : #'*WodenEngine-Core' }
Point >> gradientNoise [
	^ self signedGradientNoise * 0.5 + 0.5
]

{ #category : #'*WodenEngine-Core' }
Point >> randomGradientVector [
	| gx gy |
	self flag: 'Improve this more'.
	gx := self signedRandomNoise.
	gy := (gx*(x*x + y*y)) signedRandomNoise.
	^ gx @ gy
]

{ #category : #'*WodenEngine-Core' }
Point >> randomNoise [
	^ (self dotProduct: 37.466001434934327 @ 974.4145860776373) randomNoise
]

{ #category : #'*WodenEngine-Core' }
Point >> signedGradientNoise [
	| minX minY maxX maxY fx fy ix iy l t |
	minX := x floor.
	minY := y floor.
	maxX := minX + 1.0.
	maxY := minY + 1.0.
	fx := x - minX.
	fy := y - minY.
	ix := fx cubicHemineCurve.
	iy := fy cubicHemineCurve.

	l := ((minX@minY) randomGradientVector dotProduct: fx@fy)
		interpolateTo: ((maxX@minY) randomGradientVector dotProduct: (fx - 1.0)@fy)
		at: ix.
	t := ((minX@maxY) randomGradientVector dotProduct: fx@(fy - 1.0))
		interpolateTo: ((maxX@maxY) randomGradientVector dotProduct: (fx - 1.0)@(fy - 1.0))
		at: ix.
	^ l interpolateTo: t at: iy
]

{ #category : #'*WodenEngine-Core' }
Point >> signedRandomNoise [
	^ self randomNoise * 2.0 - 1.0

]

{ #category : #'*WodenEngine-Core' }
Point >> signedValueNoise [
	^ self valueNoise * 2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> valueNoise [
	| minX minY maxX maxY fx fy l t |
	minX := x floor.
	minY := y floor.
	maxX := minX + 1.0.
	maxY := minY + 1.0.
	fx := (x - minX) cubicHemineCurve.
	fy := (y - minY) cubicHemineCurve.

	l := (minX@minY) randomNoise interpolateTo: (maxX@minY) randomNoise at: fx.
	t := (minX@maxY) randomNoise interpolateTo: (maxX@maxY) randomNoise at: fx.
	^ l interpolateTo: t at: fy
]
