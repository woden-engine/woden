accessing
colorRamp
	^ colorRamp collect: [ :el | el edge -> el color asColor ]