instance creation
buildMorph
	morph := self morphClass basicNew
		engine: engine;
		initialize;
		canvas: self;
		extent: self canvas extent.
	^ morph