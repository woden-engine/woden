adding
addView: aView
	engine renderingProcessCritical: [
		views add: aView.
	]