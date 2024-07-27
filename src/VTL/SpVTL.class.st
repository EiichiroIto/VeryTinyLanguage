Class {
	#name : #SpVTL,
	#superclass : #SpPresenter,
	#instVars : [
		'menu',
		'output',
		'process',
		'inputQueue',
		'toolBar',
		'language'
	],
	#category : #'VTL-UI'
}

{ #category : #'world menu' }
SpVTL class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'CVTL')
		parent: #Tools;
		order: 900;
		target: self;
		action: [ self new open ]
]

{ #category : #'instance creation' }
SpVTL class >> open [

	<script>
	self new open
]

{ #category : #constants }
SpVTL >> appName [

	^ 'Very Tiny Language'
]

{ #category : #constants }
SpVTL >> appText [

	^ self appName , ' ' , self appVersion , String cr , String cr
	  , 'Copyright © 2024 Eiichiro Ito (EiichiroIto@gmail.com)'
	  , String cr , 'All rights reserved.'
]

{ #category : #constants }
SpVTL >> appVersion [

	^ '0.0.1'
]

{ #category : #process }
SpVTL >> breakProcess [

	self stopProcess.
	language break.
	self startProcess
]

{ #category : #actions }
SpVTL >> clearScreen [

	output morph
		clearScreen;
		changed;
		takeKeyboardFocus
]

{ #category : #initialization }
SpVTL >> connectPresenters [

	output morph whenKeyPressed: [ :c | self keyPressed: c ]
]

{ #category : #layout }
SpVTL >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #menu expand: false;
		  add: toolBar expand: false;
		  add: #output;
		  yourself
]

{ #category : #constants }
SpVTL >> defaultProgramTop [

	^ 16r108
]

{ #category : #constants }
SpVTL >> defaultRandomSeed [

	^ 12345
]

{ #category : #private }
SpVTL >> enterString: aString [

	aString lines do: [ :each | 
		inputQueue
			addAll: (each asArray collect: #asciiValue);
			add: Character cr asciiValue ].
	self resumeProcess
]

{ #category : #process }
SpVTL >> executionLoop [

	[ 
	language doOneCycle.
	(Delay forMilliseconds: 100) wait ] repeat
]

{ #category : #constants }
SpVTL >> extension [

	^ 'vtl'
]

{ #category : #initialization }
SpVTL >> fileMenu [

	| m |
	m := self newMenu.
	m addGroup: [ :grp | 
		grp
			addItem: [ :item | 
				item
					name: 'Load';
					action: [ self loadFile ] ];
			addItem: [ :item | 
				item
					name: 'Save';
					action: [ self saveFile ] ].
		grp
			addItem: [ :item | 
				item
					name: 'Close';
					action: [ application closeAllWindows ] ];
			addItem: [ :item | 
				item
					name: 'Quit';
					action: [ application quit ] ] ].
	^ m
]

{ #category : #accessing }
SpVTL >> getAsciiValue [

	inputQueue notEmpty ifTrue: [ ^ inputQueue removeFirst ].
	process ifNil: [ ^ nil ].
	process suspend.
	inputQueue notEmpty ifTrue: [ ^ inputQueue removeFirst ].
	self error
]

{ #category : #initialization }
SpVTL >> helpMenu [

	^ self newMenu
		  addItem: [ :item | 
			  item
				  name: 'About ' , self appName;
				  action: [ owner window showAbout ] ];
		  addItem: [ :item | 
			  item
				  name: 'Inspect';
				  action: [ self inspect ] ];
		  yourself
]

{ #category : #initialization }
SpVTL >> initialize [

	self selectLanguage: VeryTinyLanguage.
	inputQueue := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
SpVTL >> initializePresenters [

	menu := self newMenuBar.
	toolBar := self newToolbar
		           addItem: (SpToolbarButtonPresenter new
				            help: 'Load program';
				            label: 'Load';
				            icon: (self iconNamed: #glamorousOpen);
				            action: [ self loadFile ];
				            yourself);
		           addItem: (SpToolbarButtonPresenter new
				            help: 'Save program';
				            label: 'Save';
				            icon: (self iconNamed: #glamorousSave);
				            action: [ self saveFile ];
				            yourself);
		           addItem: (SpToolbarButtonPresenter new
				            help: 'Input program';
				            label: 'Input';
				            icon: (self iconNamed: #glamorousEdit);
				            action: [ self inputProgram ];
				            yourself);
		           addItem: (SpToolbarButtonPresenter new
				            help: 'Stop program';
				            label: 'Stop';
				            icon: (self iconNamed: #stop);
				            action: [ self breakProcess ];
				            yourself);
		           addItem: (SpToolbarButtonPresenter new
				            help: 'Clear screen';
				            label: 'Clear';
				            icon: (self iconNamed: #refresh);
				            action: [ self clearScreen ];
				            yourself);
		           yourself.
	output := self newMorph
		          morph: self newConsoleMorph;
		          yourself.
	self setupMenu
]

{ #category : #initialization }
SpVTL >> initializeWindow: aWindow [

	aWindow
		whenClosedDo: [ self stopProcess ];
		whenOpenedDo: [ 
			output takeKeyboardFocus.
			self startProcess ];
		initialExtent: 660 @ 500;
		title: self appName;
		aboutText: self appText
]

{ #category : #actions }
SpVTL >> inputProgram [

	| ret |
	ret := SpRequestTextDialog new
		       title: 'Input Program';
		       label: 'Enter code';
		       text: '';
		       acceptLabel: 'OK';
		       cancelLabel: 'Cancel';
		       openModal.
	ret ifNil: [ ^ self ].
	self enterString: ret.
	output takeKeyboardFocus
]

{ #category : #accessing }
SpVTL >> inputQueue [

	^ inputQueue
]

{ #category : #accessing }
SpVTL >> inputQueue: anObject [

	inputQueue := anObject
]

{ #category : #process }
SpVTL >> keyPressed: anInteger [

	anInteger = 0 ifTrue: [ ^ self ].
	inputQueue add: anInteger.
	self resumeProcess
]

{ #category : #initialization }
SpVTL >> languageMenu [

	| m classes |
	m := self newMenu.
	m addGroup: [ :grp | 
		classes := VeryTinyLanguage withAllSubclasses sort: [ :a :b | a name < b name ].
		classes do: [ :each | 
			grp addItem: [ :item | 
				item
					name: each name;
					action: [ 
						self stopProcess.
						self selectLanguage: each.
						self startProcess ] ] ] ].
	^ m
]

{ #category : #actions }
SpVTL >> loadFile [

	| file |
	file := UIManager default
		        chooseExistingFileReference: 'Load program'
		        extensions: { self extension }
		        path: FileSystem workingDirectory.
	file ifNil: [ ^ self ].
	file isFile ifFalse: [ ^ self ].
	language boundary: language programTop.
	self enterString: file contents.
	output takeKeyboardFocus
]

{ #category : #constants }
SpVTL >> memorySize [

	^ 1024 * 32
]

{ #category : #'instance creation' }
SpVTL >> newConsoleMorph [

	^ VTLConsoleMorph new
]

{ #category : #'instance creation' }
SpVTL >> newMemory: anInteger [

	^ VTLMemory new
		  allocate: anInteger;
		  yourself
]

{ #category : #accessing }
SpVTL >> output [

	^ output
]

{ #category : #accessing }
SpVTL >> output: anObject [

	output := anObject
]

{ #category : #accessing }
SpVTL >> process [

	^ process
]

{ #category : #accessing }
SpVTL >> process: anObject [

	process := anObject
]

{ #category : #accessing }
SpVTL >> putAsciiValue: anInteger [

	output morph putAsciiValue: anInteger
]

{ #category : #process }
SpVTL >> resumeProcess [

	process ifNil: [ ^ self ].
	process isSuspended ifFalse: [ ^ self ].
	process resume
]

{ #category : #actions }
SpVTL >> saveFile [

	| file dummyUI |
	file := UIManager default
		        chooseForSaveFileReference: 'Save program'
		        extensions: { self extension }
		        path: FileSystem workingDirectory.
	file ifNil: [ ^ self ].
	file := file withExtension: self extension.
	dummyUI := VTLNonInteractiveUI new.
	language ui in: [ :oldUI | 
		[ 
		language ui: dummyUI.
		language doList ] ensure: [ language ui: oldUI ] ].
	file writeStreamDo: [ :stream | 
		stream nextPutAll: dummyUI outputString ].
	output takeKeyboardFocus
]

{ #category : #private }
SpVTL >> selectLanguage: aClass [

	language := aClass new.
	self setupFor: language
]

{ #category : #initialization }
SpVTL >> setupFor: aCVTL [

	| memory |
	memory := self newMemory: self memorySize.
	aCVTL memory: memory.
	aCVTL memoryLimit: self memorySize.
	aCVTL programTop: self defaultProgramTop.
	aCVTL boundary: self defaultProgramTop.
	memory wordAt: aCVTL randomAddress put: self defaultRandomSeed
]

{ #category : #initialization }
SpVTL >> setupMenu [

	menu
		addItem: [ :item | 
			item
				name: 'File';
				subMenu: self fileMenu ];
		addItem: [ :item | 
			item
				name: 'Language';
				subMenu: self languageMenu ];
		addItem: [ :item | 
			item
				name: 'Help';
				subMenu: self helpMenu ]
]

{ #category : #process }
SpVTL >> startProcess [

	self stopProcess.
	language ui: self.
	process := [ 
	           self executionLoop.
	           process := nil ] fork
]

{ #category : #process }
SpVTL >> stopProcess [

	process ifNil: [ ^ self ].
	process terminate.
	process := nil
]
