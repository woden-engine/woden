submorphs-add/remove
delete
	super delete.
	
	self terminateRenderThread.
	osWindowRenderer destroy.
	osWindow destroy.
	osWindow := nil.
	closeCallback value.