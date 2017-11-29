rendering
createMainBlocSpace
	| b1 b2 box space b3 b4 |
	
	BlMaterialTheme load.
	
	b1 := BrTextArea new 
		width: 400;
		placeholder: 'Flexible TextArea';
		margin:(BlInsets all:5);
		fontColor: Color blue;
		constraintsDo:[:c| c alignCenter].	

	b2 := BrTextArea new 
		extent: 400@ 70;
		placeholder: 'Fixed TextArea';
		margin:(BlInsets all:5);
		fontColor: Color blue;
		constraintsDo:[:c| c alignCenter].	
			
	b3 := BrTextArea new 
		width: 400;
		wrapText: true;
		placeholder: 'Flexible Wrapped TextArea';
		text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum rutrum eu turpis eget semper. Nam ligula dolor, finibus et leo nec, bibendum vestibulum metus. Aliquam feugiat, dui vel ornare volutpat, ligula nunc imperdiet elit, a tincidunt metus nisi id augue. Suspendisse luctus eu magna non iaculis. Aenean nec rutrum quam. Vestibulum luctus porttitor justo, in pharetra dolor auctor nec. Nullam pretium sodales porta.';
		margin:(BlInsets all:5);
		fontColor: Color blue;
		constraintsDo:[:c| c alignCenter].	
	
	b4 := BrTextArea new 
		extent: 400@70;
		wrapText: true;
		placeholder: 'Fixed Wrapped TextArea';
		margin:(BlInsets all:5);
		fontColor: Color blue;
		constraintsDo:[:c| c alignCenter].	
			
	box := BrVBoxPane new
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{b3}.
	
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		addChild: box.
	
	^ space
	