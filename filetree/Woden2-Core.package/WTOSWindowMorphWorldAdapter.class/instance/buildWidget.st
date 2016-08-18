factory
buildWidget
	^ WTOSWindowMorphWorld new
		layoutPolicy: ProportionalLayout new;
		model: model;
		isResizeable: self isResizeable;
		yourself