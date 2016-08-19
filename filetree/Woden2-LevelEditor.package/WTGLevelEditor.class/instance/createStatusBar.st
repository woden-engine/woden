rendering
createStatusBar
	^ BlElement new 
		constraintsDo:[:c| c hMatchParent ; alignCenter];
		background:(BlBackground fill: Color lightGray). 