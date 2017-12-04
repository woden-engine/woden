as yet unclassified
initialize
	"
	self initialize
	"
	
	KeySymbolMap := IdentityDictionary newFromPairs: { 
		#A . OSK_a .
		#B . OSK_b .
		#C . OSK_c .
		#D . OSK_d .
		#E . OSK_e .
		#F . OSK_f .
		#G . OSK_g .
		#H . OSK_h .
		#I . OSK_i .
		#J . OSK_j .
		#K . OSK_k .
		#L . OSK_l .
		#M . OSK_m .
		#N . OSK_n .
		#O . OSK_o .
		#P . OSK_p .
		#Q . OSK_q .
		#R . OSK_r .
		#S . OSK_s .
		#T . OSK_t .
		#U . OSK_u .
		#W . OSK_w .
		#X . OSK_x .
		#Y . OSK_y .
		#Z . OSK_z .
		#SPACE . OSK_SPACE .
		#KP_SPACE . OSK_SPACE .
		#EIGHT . OSK_UP .
		#FOUR . OSK_LEFT .
		#SIX . OSK_RIGHT .
		#FIVE . OSK_DOWN .
		#LESS . OSK_LCTRL.
	}.
	
	MouseButtonMap := IdentityDictionary newFromPairs: #(
		4 1 "Left"
		2 3 "Right"
		1 2 "Middle"
	)