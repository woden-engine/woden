rendering
createToolbarButtonLabel: label action: action
	^ BrButton new
		text: label;
		margin:(BlInsets all:5);
		constraintsDo:[:c| c alignCenterLeft];
		addEventHandler: (BlOnClickHandler do: action)