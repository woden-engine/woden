Extension { #name : #Point }

{ #category : #'*WodenEngine-Core' }
Point >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: gain initialAmplitude: initialAmplitude tiledWith: tilingPeriod with: aBlock [
	| result currentCoord amplitude currentTilingPeriod |
	result := 0.0.
	currentCoord := self.
	currentTilingPeriod := tilingPeriod.
	amplitude := initialAmplitude.
	
	1 to: octaves do: [ :i |
		result := result + (aBlock noiseValueAt: currentCoord withAmplitude: amplitude).
		currentCoord := currentCoord * lacunarity.
		currentTilingPeriod := currentTilingPeriod*lacunarity.
		amplitude = amplitude * gain
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
	| gx gy il |
	self flag: 'Improve this more'.
	gx := self signedRandomNoise.
	gy :=(gx*(x*x + y*y)) signedRandomNoise.
	il := 1.0 / (gx*gx + gy*gy max: 1.0).
	^ (gx * il) @ (gy *il)
]

{ #category : #'*WodenEngine-Core' }
Point >> randomNoise [
	^ (self dotProduct: 37.466001434934327 @ 974.4145860776373) randomNoise
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
Point >> signedGradientNoiseTiledWith: tilingPeriod [
	| minX minY maxX maxY fx fy ix iy l t |
	minX := x floor floorModule: tilingPeriod x.
	minY := y floor floorModule: tilingPeriod y.
	maxX := minX + 1.0 floorModule: tilingPeriod x.
	maxY := minY + 1.0 floorModule: tilingPeriod y.
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
Point >> signedValueNoiseTiledWith: tilingPeriod [
	^ (self valueNoiseTiledWith: tilingPeriod) * 2.0 - 1.0
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

{ #category : #'*WodenEngine-Core' }
Point >> valueNoiseTiledWith: tilingPeriod [
	| minX minY maxX maxY fx fy l t |
	minX := x floor floorModule: tilingPeriod x.
	minY := y floor floorModule: tilingPeriod y.
	maxX := minX + 1.0 floorModule: tilingPeriod x.
	maxY := minY + 1.0 floorModule: tilingPeriod y.
	fx := (x - minX) cubicHemineCurve.
	fy := (y - minY) cubicHemineCurve.

	l := (minX@minY) randomNoise interpolateTo: (maxX@minY) randomNoise at: fx.
	t := (minX@maxY) randomNoise interpolateTo: (maxX@maxY) randomNoise at: fx.
	^ l interpolateTo: t at: fy
]

{ #category : #'*WodenEngine-Core' }
Point >> worleyNoise [
	| startCellX startCellY fx fy result cellX cellY point dx dy |
	startCellX := x floor.
	startCellY := y floor.
	fx := x - startCellX.
	fy := y - startCellY.
	
	result := Float infinity.
	-1 to: 1 do: [ :cdy |
		-1 to: 1 do: [ :cdx |
			cellX := startCellX + cdx.
			cellY := startCellY + cdy.
			point := (cellX@cellY) randomVector.

			dx := fx - (point x + cdx).
			dy := fy - (point y + cdy).
			result := result min: (dx*dx) + (dy*dy)
		]
	].

	^ result sqrt
]

{ #category : #'*WodenEngine-Core' }
Point >> worleyNoiseTiledWith: tilingPeriod [
	| startCellX startCellY fx fy result cellX cellY point dx dy |
	startCellX := x floor.
	startCellY := y floor.
	fx := x - startCellX.
	fy := y - startCellY.
	
	result := Float infinity.
	-1 to: 1 do: [ :cdy |
		-1 to: 1 do: [ :cdx |
			cellX := startCellX + cdx floorModule: tilingPeriod x.
			cellY := startCellY + cdy floorModule: tilingPeriod y.
			point := (cellX@cellY) randomVector.

			dx := fx - (point x + cdx).
			dy := fy - (point y + cdy).
			result := result min: (dx*dx) + (dy*dy)
		]
	].

	^ result sqrt
]
