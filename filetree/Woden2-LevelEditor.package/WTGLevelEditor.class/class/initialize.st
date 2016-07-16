as yet unclassified
initialize
	super initialize.
	
	DefaultSettingsForViews := {
		"Top Left"
		[ :view | view orthographic; wireframe; topView ].
	
		"Top Right"
		[ :view |
			view perspective; solid; frontView. 
			view cameraTransform translateByZ: 3.0; translateByY: 1.0.
		].
		
		"Bottom Left"
		[ :view | view orthographic; wireframe; frontView ].
		
		"Bottom Right"
		[ :view | view orthographic; wireframe; sideView ].
	}