rendering
createMainBlocSpace
	| b1 b2 box space|
	
	BlMaterialTheme load.
	
	b1 := BrLabel new 
		text: 'simple label';
		margin:(BlInsets all:5);
		fontColor: Color blue;
		constraintsDo:[:c| c alignCenter].	
	
	b2 := BrLabel new 
		text: 'label with icon';
		margin:(BlInsets all:5);
		fontColor: Color black;
		fontSize: 14;
		constraintsDo:[:c| c alignCenter]..
	
	box := BrHBoxPane new
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{b1.b2}.
	
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		addChild: box.
	
	^ space
	