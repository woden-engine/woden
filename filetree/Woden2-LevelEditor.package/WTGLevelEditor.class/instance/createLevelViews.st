rendering
createLevelViews
	| topLeft topRight bottomLeft bottomRight topHorizontalPane bottomHorizontalPane |
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

	^ BrVBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter; weight: 4];
		addChildren:{topHorizontalPane . bottomHorizontalPane}.