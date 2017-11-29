rendering
activateBlocSpace: aSpace
	| universe |
	universe := BlUniverse default.
	universe
		start;
		addPulseListener: aSpace