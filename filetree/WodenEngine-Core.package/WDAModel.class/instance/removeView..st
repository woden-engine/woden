adding
removeView: aView
	engine renderingProcessCritical: [
		views remove: aView.
		views ifEmpty: [ self allViewsAreClosed ]
	]