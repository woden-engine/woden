testing
isBoxOutside: other
	<argument: #other type: #(SelfType object)>
	^ other max x < min x or:
	[ other max y < min y or:
	[ other max z < min z or:
	[ other min x > max x or:
	[ other min y > max y or:
	[ other min z > max z ]]]]]