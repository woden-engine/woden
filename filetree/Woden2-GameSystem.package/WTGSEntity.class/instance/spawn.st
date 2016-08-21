as yet unclassified
spawn
	| allComponents |
	allComponents := self componentsCollect: #yourself.
	"Copy the list of components because they could be calling spawn recursively."
	allComponents do: #spawn