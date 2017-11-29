utility
checkNotEmpty
	"Raise an error if no elements have been added"
	elements ifEmpty: [ self error: 'Please specify what are the elements I should operate on using #elements:' ]