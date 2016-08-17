rendering
createMainBlocSpace
	| topLeft topRight bottomLeft bottomRight space topHorizontalPane bottomHorizontalPane verticalPane materialListView contentBarHorizontalPane |
	
	BlMaterialTheme load.
	
	topLeft := WTGLevelEditorView for: self.
	topRight := WTGLevelEditorView for: self.
	bottomLeft := WTGLevelEditorView for: self.
	bottomRight := WTGLevelEditorView for: self.
	levelViews := { topLeft . topRight . bottomLeft . bottomRight }.
	
	levelViews do: [ :view |
		view
			constraintsDo:[:c| c vhMatchParent ; alignCenter];
			background: Color transparent.
	].
				
	topHorizontalPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{topLeft . topRight}.
		
	bottomHorizontalPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{bottomLeft . bottomRight}.

	verticalPane := BrVBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter; weight: 4];
		addChildren:{topHorizontalPane . bottomHorizontalPane}.

	materialListView := WTGLevelEditorMaterialListView for: self.
	materialListView
		background: Color gray;
		constraintsDo:[:c| c vhMatchParent ; alignCenter; weight: 1].
		
	contentBarHorizontalPane := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{verticalPane . materialListView}.
		
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		background: Color transparent;
		addChild: contentBarHorizontalPane.
	
	^ space
	