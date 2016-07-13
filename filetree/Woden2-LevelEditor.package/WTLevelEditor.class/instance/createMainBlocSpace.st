rendering
createMainBlocSpace
	| b1 box space|
	
	BlMaterialTheme load.
	
	b1 := BrLabel new 
		text: 'Level editor label';
		margin:(BlInsets all:5);
		fontColor: Color blue;
		constraintsDo:[:c| c alignCenter].	
		
	box := BrHBoxPane new
		background: Color transparent;
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{b1 }.
	
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		background: Color transparent;
		addChild: box.
	
	^ space
	