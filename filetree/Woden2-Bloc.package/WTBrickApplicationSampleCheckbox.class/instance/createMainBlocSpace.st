rendering
createMainBlocSpace
	| b1 b2 b3 b4 b5 box space|
	
	BlMaterialTheme load.
	
	b1 := BrCheckbox new 
		text: 'check me';
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].
		
	b1 checkedProperty onChangedDo: [:v| b1 text: 'i am checked: ', v asString].
	
	b2 := BrCheckbox new 
		text: 'cb with icon';
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter];
		icon: (BlSvgShape new svg: BlIcons circleCross;extent:20@20).
	
	b3 := BrCheckbox new 
		text: 'cb outlined';
		addStyleClass: #outlined;
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].
		
	b4 := BrCheckbox new 
		icon: (BlSvgShape new svg: BlIcons circleCross;extent:20@20);
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].	
	
	b5 := BrCheckbox new 
		addStyleClass: #outlined;
		icon: (BlSvgShape new svg: BlIcons circleCross;extent:20@20);
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenter].	
	
	box := BrHBoxPane new
		constraintsDo:[:c| c vhMatchParent ; alignCenter];
		addChildren:{b1. b2. b3. b4. b5}.
	
	space := BlSpace new.
	space hostWindow: (WTBlVirtualWindow new engine: engine).
	space root
		addChild: box.
	
	^ space
	