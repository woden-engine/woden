rendering
createMainBlocSpace
	| space c1 c2 p |
	c1 := BlElement new
		extent: 80 @ 80;
		background:(BlBackground fill: Color green).
	
	c2 := BlElement new
		extent: 80 @ 80;
		background:(BlBackground fill: Color red).
	
	
	p := BlElement new
		layout: BlLinearLayout vertical;
		extent: 200 @ 300;
		position: 200@100;
		background:(BlBackground fill: Color blue);
		addChild: c1;
		addChild: c2.
		
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root addChild: p.
	space root addChild: (BlFPSCounter on: space).
	space root addEventHandler:
			(BlEventHandler
				on: BlDblClickEvent
				do: [ :evt | BlNodeSelection on: evt target ]).
	
	^ space
	