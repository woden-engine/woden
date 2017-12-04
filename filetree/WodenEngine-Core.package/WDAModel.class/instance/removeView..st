adding
removeView: aView
	engine renderingProcessCritical: [
		views remove: aView.
	]