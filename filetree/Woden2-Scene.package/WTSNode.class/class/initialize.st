class initialization
initialize
	super initialize.
	
	RenderPriorityEditorOpaqueBefore := 0.

	RenderPriorityOpaque := 200.
	RenderPriorityOpaqueStatic := RenderPriorityOpaque.
	RenderPriorityDefault := RenderPriorityOpaque.

	RenderPriorityEditorOpaqueAfter := 800.
	
	RenderPriorityTranslucent := 1000.
	
	RenderPriorityEditorTranslucentAfter := 1500.

	RenderPriorityTranslucentSorted := 2000.
	
	RenderPriorityEditorTranslucentSortedAfter := 2500.
	