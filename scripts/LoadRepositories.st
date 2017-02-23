FileStream stdout nextPutAll: 'Loading LowcodeOpalCompiler'; lf.

"Load the runtime changes that are required for Lowcode"
'scripts/LowcodeRuntimeChanges.cs' asFileReference fileIn.

(ConfigurationOfLowcode project version: #stable) load: #(WithOpalCompiler)

"Load Git file tree"
FileStream stdout nextPutAll: 'Loading GitFileTree'; lf.

Metacello new
  baseline: 'FileTree';
  repository: 'github://dalehenrich/filetree:pharo6.0_dev/repository';
  load: 'Git'

"Use the modified version of monticello"
'scripts/MonticelloMethodSorting.cs' asFileReference fileIn.

"Load Woden 2"
FileStream stdout nextPutAll: 'Loading Woden2'; lf.
Metacello new
	baseline: 'Woden2';
	repository: ('gitfiletree://' , ('filetree' asFileReference asAbsolute fullName));
	load.

"Save the image"
(Smalltalk saveAs: 'woden2')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
