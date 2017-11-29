class initialization
initialize
	"
	self initialize.
	"
	BufferRegistry := WeakSet new.
	SessionManager default register: (ClassSessionHandler forClassNamed: self name).