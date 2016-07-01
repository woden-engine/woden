rendering
createMainBlocSpace
	| space |
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		addChild: (BlFPSCounter on:space);
		addChild: (BlBasicExamples newRectangle position: 10 @ 50);
		addChild: (BlBasicExamples newPolygon position: 220 @ 0);
		addChild: (BlBasicExamples newRoundedRectangle position: 430 @ 50);
		addChild: (BlBasicExamples newEllipse position: 10 @ 200);
		addChild: (BlBasicExamples newCircle position: 250 @ 200);
		addChild: (BlBasicExamples newSquare position: 400 @ 200).
	
	^ space
	