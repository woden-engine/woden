Extension { #name : #Number }

{ #category : #'*WodenEngine-Core' }
Number >> asVisualizationColor [
	^ Color r: self g: self b: self
]

{ #category : #'*WodenEngine-Core' }
Number >> cubicHemiteCurve [
	^ self * self * (3.0 - (2.0*self))
]

{ #category : #'*WodenEngine-Core' }
Number >> floorFract [
	^ self - self floor
]

{ #category : #'*WodenEngine-Core' }
Number >> floorModule: period [
	^ self - ((self / period) floor * period)
]

{ #category : #'*WodenEngine-Core' }
Number >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: gain tiledWith: tilingPeriod with: aBlock [
	| result currentCoord amplitude currentTilingPeriod amplitudeSum |
	result := 0.0.
	currentCoord := self.
	currentTilingPeriod := tilingPeriod.
	amplitude := 0.5.
	amplitudeSum := 0.0.
	
	1 to: octaves do: [ :i |
		result := result + (aBlock noiseValueAt: currentCoord withAmplitude: amplitude).
		currentCoord := currentCoord * lacunarity.
		currentTilingPeriod := currentTilingPeriod*lacunarity.
		amplitudeSum := amplitudeSum + amplitude.
		amplitude = amplitude * gain
	].

	^ result / amplitudeSum

]

{ #category : #'*WodenEngine-Core' }
Number >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: gain with: aBlock [
	| result currentCoord amplitude amplitudeSum |
	result := 0.0.
	currentCoord := self.
	amplitude := 0.5.
	amplitudeSum := 0.0.
	
	1 to: octaves do: [ :i |
		result := result + (aBlock noiseValueAt: currentCoord withAmplitude: amplitude).
		currentCoord := currentCoord * lacunarity.
		amplitudeSum := amplitudeSum + amplitude.
		amplitude := amplitude * gain
	].

	^ result / amplitudeSum

]

{ #category : #'*WodenEngine-Core' }
Number >> fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity with: aBlock [
	^ self fractionalBrownianMotionOctaves: octaves lacunarity: lacunarity gain: lacunarity reciprocal with: aBlock
]

{ #category : #'*WodenEngine-Core' }
Number >> fuzzyAnd: other [
	^ self min: other
]

{ #category : #'*WodenEngine-Core' }
Number >> fuzzyNot [
	^ 1.0 - self
]

{ #category : #'*WodenEngine-Core' }
Number >> fuzzyOr: other [
	^ self max: other
]

{ #category : #'*WodenEngine-Core' }
Number >> fuzzyXor: other [
	^ ((1.0 - self) min: other) fuzzyOr: (self min: (1.0 - other))
]

{ #category : #'*WodenEngine-Core' }
Number >> gradientNoise [
	^ self signedGradientNoise * 0.5 + 0.5
]

{ #category : #'*WodenEngine-Core' }
Number >> productFuzzyAnd: other [
	^ self * other
]

{ #category : #'*WodenEngine-Core' }
Number >> productFuzzyNot [
	^ self fuzzyNot
]

{ #category : #'*WodenEngine-Core' }
Number >> productFuzzyOr: other [
	^ self + other - (self * other)
]

{ #category : #'*WodenEngine-Core' }
Number >> productFuzzyXor: other [
	^ ((1.0 - self) * other) productFuzzyOr: self * (1.0 - other)
]

{ #category : #'*WodenEngine-Core' }
Number >> randomNoise [
	^ (self sin * 543414.1875) floorFract 
	
]

{ #category : #'*WodenEngine-Core' }
Number >> signedGradientNoise [
	| l f |
	l := self floor.
	f := self - l.
	^ (l signedRandomNoise * f) smoothInterpolateTo: ((l+1.0) signedRandomNoise * (f-1.0)) at: f
]

{ #category : #'*WodenEngine-Core' }
Number >> signedRandomNoise [
	^ self randomNoise * 2.0 - 1.0

]

{ #category : #'*WodenEngine-Core' }
Number >> signedValueNoise [
	^ self valueNoise * 2.0 - 1.0
]

{ #category : #'*WodenEngine-Core' }
Number >> smoothInterpolateTo: aNumber at: param [
	^ self interpolateTo: aNumber at: param cubicHemiteCurve
]

{ #category : #'*WodenEngine-Core' }
Number >> smoothStepFrom: leftEdge to: rightEdge [
	self <= leftEdge ifTrue: [ ^ 0.0 ].
	self >= rightEdge ifTrue: [ ^ 1.0 ].
	
	^ ((self - leftEdge) / (rightEdge - leftEdge)) cubicHemiteCurve
]

{ #category : #'*WodenEngine-Core' }
Number >> stepEdge: edge [
	^ self < edge ifTrue: [0.0] ifFalse: [ 1.0 ]
]

{ #category : #'*WodenEngine-Core' }
Number >> turbulence [
	^ self turbulenceScales: 4
]

{ #category : #'*WodenEngine-Core' }
Number >> turbulenceScales: scale [
	^ self fractionalBrownianMotionOctaves: scale lacunarity: 2.0 gain: 0.5 with: #signedGradientNoise

]

{ #category : #'*WodenEngine-Core' }
Number >> valueNoise [
	| lower |
	lower := self floor.
	^ lower randomNoise interpolateTo: (lower + 1.0) randomNoise at: (self - lower) cubicHemiteCurve
]
