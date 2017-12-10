rendering preparations
selectShadowCastingLights
	| lightSource |
	shadowCastingLights := Array new: self maxShadowCastingLightCount.
	shadowCastingLightCount := 0.
	visibleLightSources do: [ :l |
		lightSource := l first.
		lightSource isSpotLight ifTrue: [
			shadowCastingLightCount := shadowCastingLightCount + 1.
			shadowCastingLights at: shadowCastingLightCount put: lightSource.
			shadowCastingLightCount = shadowCastingLights ifTrue: [ ^ self ]
		]
	]