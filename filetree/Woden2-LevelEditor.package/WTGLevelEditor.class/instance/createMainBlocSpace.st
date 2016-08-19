rendering
createMainBlocSpace
	| space contentPane mainPane |
	
	BlMaterialTheme load.
	
	contentPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{"self createLeftToolPane . "self createLevelViews . self createRightToolPane}.

	mainPane := BrVBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren: { "self createMenuBar ." self createToolBar . contentPane . self createStatusBar }.
		
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		background: Color transparent;
		addChild: mainPane.
	
	^ space
	