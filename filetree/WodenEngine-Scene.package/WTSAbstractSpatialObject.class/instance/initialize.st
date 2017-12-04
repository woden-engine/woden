initialization
initialize
	super initialize.
	renderPriority := RenderPriorityDefault.
	objectState := WTGenericObjectState new.
	objectState
		visible: 1;
		color: Color white asWMVector4F.
	