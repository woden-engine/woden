actions
playInExternalWindow
	WTGSLevelPlayer new
		"initializeWithEngine: engine;"
		map: map playModeCopy;
		spawn;
		openInOSWindow.