initialization
initialize
	super initialize.
	renderPriority := RenderPriorityDefault.
	objectState := WTGenericObjectState new.
	objectState color: Color white asWMVector4F.
	