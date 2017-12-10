rendering preparations
prepareShadowCastingFor: viewports
	"Sort the lights."
	visibleLightSources sort: [ :a :b |
		a second < b second
	].

	self selectShadowCastingLights.