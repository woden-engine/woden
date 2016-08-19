comparing
closeTo: other
	<argument: #other type: #(WMVector2F object)>
	^ (x closeTo: other x) and: [ y closeTo: other y ]