Extension { #name : #Point }

{ #category : #'*WodenEngine-Core' }
Point >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: gain initialAmplitude: initialAmplitude tiledWith: tilingPeriod with: aBlock [
	| result currentCoord amplitude currentTilingPeriod |
	result := 0.0.
	currentCoord := self.
	currentTilingPeriod := tilingPeriod.
	amplitude := initialAmplitude.
	
	1 to: octaves do: [ :i |
		result := result + (aBlock noiseValueAt: currentCoord withAmplitude: amplitude withTilingPeriod: currentTilingPeriod).
		currentCoord := currentCoord * lacunarity.
		currentTilingPeriod := currentTilingPeriod*lacunarity.
		amplitude := amplitude * gain
	].

	^ result

]

{ #category : #'*WodenEngine-Core' }
Point >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: gain initialAmplitude: initialAmplitude with: aBlock [
	| result currentCoord amplitude |
	result := 0.0.
	currentCoord := self.
	amplitude := initialAmplitude.
	
	1 to: octaves do: [ :i |
		result := result + (aBlock noiseValueAt: currentCoord withAmplitude: amplitude).
		currentCoord := currentCoord * lacunarity.
		amplitude := amplitude * gain
	].

	^ result

]

{ #category : #'*WodenEngine-Core' }
Point >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity initialAmplitude: initialAmplitude tiledWith: tilingPeriod with: aBlock [
	^ self fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: lacunarity reciprocal initialAmplitude: initialAmplitude tiledWith: tilingPeriod with: aBlock
]

{ #category : #'*WodenEngine-Core' }
Point >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity initialAmplitude: initialAmplitude with: aBlock [
	^ self fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: lacunarity reciprocal initialAmplitude: initialAmplitude with: aBlock
]

{ #category : #'*WodenEngine-Core' }
Point >> gradientNoise [
	^ self signedGradientNoise * 0.5 + 0.5
]

{ #category : #'*WodenEngine-Core' }
Point >> gradientNoiseTiledWith: tilingPeriod [
	^ (self signedGradientNoiseTiledWith: tilingPeriod) * 0.5 + 0.5
]

{ #category : #'*WodenEngine-Core' }
Point >> randomGradientVector [
	| gx gy |
	gx := self signedRandomNoise.
	gy := self signedRandomNoise_second.
	^ gx@gy
]

{ #category : #'*WodenEngine-Core' }
Point >> randomNoise [
	^ (self dotProduct: 37.466001434934327 @ 974.4145860776373) randomNoise
]

{ #category : #'*WodenEngine-Core' }
Point >> randomNoise2 [
	^ self randomNoise @ self randomNoise_second
]

{ #category : #'*WodenEngine-Core' }
Point >> randomNoise_second [
	^ (self dotProduct: 718.2194021149629 @  53.063644586626275) randomNoise
]

{ #category : #'*WodenEngine-Core' }
Point >> randomVector [
	| gx gy |
	self flag: 'Improve this more'.
	gx := self randomNoise.
	gy :=(gx*(x*x + y*y)) randomNoise.
	^ gx @ gy
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
	ix := fx cubicHemiteCurve.
	iy := fy cubicHemiteCurve.

	l := ((minX@minY) randomGradientVector dotProduct: fx@fy)
		interpolateTo: ((maxX@minY) randomGradientVector dotProduct: (fx - 1.0)@fy)
		at: ix.
	t := ((minX@maxY) randomGradientVector dotProduct: fx@(fy - 1.0))
		interpolateTo: ((maxX@maxY) randomGradientVector dotProduct: (fx - 1.0)@(fy - 1.0))
		at: ix.
	^ l interpolateTo: t at: iy
]

{ #category : #'*WodenEngine-Core' }
Point >> signedGradientNoiseTiledWith: tilingPeriod [
	| minX minY maxX maxY fx fy ix iy l t |
	minX := x floor floorModule: tilingPeriod x.
	minY := y floor floorModule: tilingPeriod y.
	maxX := minX + 1.0 floorModule: tilingPeriod x.
	maxY := minY + 1.0 floorModule: tilingPeriod y.
	fx := x - minX.
	fy := y - minY.
	ix := fx cubicHemiteCurve.
	iy := fy cubicHemiteCurve.

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
Point >> signedRandomNoise_second [
	^ self randomNoise_second * 2.0 - 1.0

]

{ #category : #'*WodenEngine-Core' }
Point >> signedValueNoise [
	^ self valueNoise * 2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedValueNoiseTiledWith: tilingPeriod [
	^ (self valueNoiseTiledWith: tilingPeriod) * 2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedVoronoiNoise [
	^ self voronoiNoise*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedVoronoiNoiseF1 [
	^ self voronoiNoiseF1*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedVoronoiNoiseF1TiledWith: tilingPeriod [
	^ (self voronoiNoiseF1TiledWith: tilingPeriod)*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedVoronoiNoiseF2 [
	^ self voronoiNoiseF2*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedVoronoiNoiseF2TiledWith: tilingPeriod [
	^ (self voronoiNoiseF2TiledWith: tilingPeriod)*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedVoronoiNoiseTiledWith: tilingPeriod [
	^ (self voronoiNoiseTiledWith: tilingPeriod)*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedWorleyNoise [
	^ self worleyNoise*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> signedWorleyNoiseTiledWith: tilingPeriod [
	^ (self worleyNoiseTiledWith: tilingPeriod)*2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Point >> turbulence [
	^ self turbulenceScales: 4
]

{ #category : #'*WodenEngine-Core' }
Point >> turbulenceScales: scale [
	^ self fractionalBrownianMotionOctaves: scale lacunarity: 2.0 gain: 0.5 initialAmplitude: 1.0 with: #signedGradientNoise

]

{ #category : #'*WodenEngine-Core' }
Point >> valueNoise [
	| minX minY maxX maxY fx fy l t |
	minX := x floor.
	minY := y floor.
	maxX := minX + 1.0.
	maxY := minY + 1.0.
	fx := (x - minX) cubicHemiteCurve.
	fy := (y - minY) cubicHemiteCurve.

	l := (minX@minY) randomNoise interpolateTo: (maxX@minY) randomNoise at: fx.
	t := (minX@maxY) randomNoise interpolateTo: (maxX@maxY) randomNoise at: fx.
	^ l interpolateTo: t at: fy
]

{ #category : #'*WodenEngine-Core' }
Point >> valueNoiseTiledWith: tilingPeriod [
	| minX minY maxX maxY fx fy l t |
	minX := x floor floorModule: tilingPeriod x.
	minY := y floor floorModule: tilingPeriod y.
	maxX := minX + 1.0 floorModule: tilingPeriod x.
	maxY := minY + 1.0 floorModule: tilingPeriod y.
	fx := (x - minX) cubicHemiteCurve.
	fy := (y - minY) cubicHemiteCurve.

	l := (minX@minY) randomNoise interpolateTo: (maxX@minY) randomNoise at: fx.
	t := (minX@maxY) randomNoise interpolateTo: (maxX@maxY) randomNoise at: fx.
	^ l interpolateTo: t at: fy
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoise [
	^ self voronoiNoiseComponents first
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseComponents [
	| startCellX startCellY fx fy cellX cellY point dx dy f1 f2 value |
	startCellX := x floor.
	startCellY := y floor.
	fx := x - startCellX.
	fy := y - startCellY.
	
	f1 := Float infinity.
	f2 := Float infinity.
	-1 to: 1 do: [ :cdy |
		-1 to: 1 do: [ :cdx |
			cellX := startCellX + cdx.
			cellY := startCellY + cdy.
			point := (cellX@cellY) randomVector.

			dx := fx - (point x + cdx).
			dy := fy - (point y + cdy).
			value := (dx*dx) + (dy*dy).
			value < f1 ifTrue: [
				f2 := f1.
				f1 := value
			] ifFalse: [
				value < f2 ifTrue: [ 
					f2 := value
				]
			]
		]
	].

	^ {f1 sqrt . f2 sqrt}
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseComponentsTiledWith: tilingPeriod [
	| startCellX startCellY fx fy cellX cellY point dx dy f1 f2 value |
	startCellX := x floor.
	startCellY := y floor.
	fx := x - startCellX.
	fy := y - startCellY.
	
	f1 := Float infinity.
	f2 := Float infinity.
	-1 to: 1 do: [ :cdy |
		-1 to: 1 do: [ :cdx |
			cellX := startCellX + cdx floorModule: tilingPeriod x.
			cellY := startCellY + cdy floorModule: tilingPeriod y.
			point := (cellX@cellY) randomVector.

			dx := fx - (point x + cdx).
			dy := fy - (point y + cdy).
			value := (dx*dx) + (dy*dy).
			value < f1 ifTrue: [
				f2 := f1.
				f1 := value
			] ifFalse: [
				value < f2 ifTrue: [ 
					f2 := value
				]
			]
		]
	].

	^ {f1 sqrt . f2 sqrt}
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseF1 [
	^ self voronoiNoiseComponents first
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseF1TiledWith: tilingPeriod [
	^ (self voronoiNoiseComponentsTiledWith: tilingPeriod) first
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseF2 [
	^ self voronoiNoiseComponents second
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseF2TiledWith: tilingPeriod [
	^ (self voronoiNoiseComponentsTiledWith: tilingPeriod) second
]

{ #category : #'*WodenEngine-Core' }
Point >> voronoiNoiseTiledWith: tilingPeriod [
	^ (self voronoiNoiseComponentsTiledWith: tilingPeriod) first
]

{ #category : #'*WodenEngine-Core' }
Point >> worleyNoise [
	| components |
	components := self voronoiNoiseComponents.
	^ components second - components first
]

{ #category : #'*WodenEngine-Core' }
Point >> worleyNoiseTiledWith: tilingPeriod [
	| components |
	components := self voronoiNoiseComponentsTiledWith: tilingPeriod.
	^ components second - components first
]
