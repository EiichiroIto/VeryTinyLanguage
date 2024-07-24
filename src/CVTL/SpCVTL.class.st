Class {
	#name : #SpCVTL,
	#superclass : #SpPresenter,
	#instVars : [
		'cvtl',
		'menu',
		'output',
		'process',
		'inputQueue',
		'toolBar'
	],
	#category : #'CVTL-UI'
}

{ #category : #'world menu' }
SpCVTL class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'CVTL')
		parent: #Tools;
		order: 900;
		target: self;
		action: [ self new open ]
]

{ #category : #'instance creation' }
SpCVTL class >> open [

	<script>
	self new open
]

{ #category : #constants }
SpCVTL >> appName [

	^ 'Very Tiny Language'
]

{ #category : #constants }
SpCVTL >> appText [

	^ self appName , ' ' , self appVersion , String cr , String cr
	  , 'Copyright © 2024 Eiichiro Ito (EiichiroIto@gmail.com)'
	  , String cr , 'All rights reserved.'
]

{ #category : #constants }
SpCVTL >> appVersion [

	^ '0.0.1'
]

{ #category : #process }
SpCVTL >> breakProcess [

	self stopProcess.
	cvtl break.
	self startProcess
]

{ #category : #actions }
SpCVTL >> clearScreen [

	output morph
		clearScreen;
		changed;
		takeKeyboardFocus
]

{ #category : #initialization }
SpCVTL >> connectPresenters [

	output morph whenKeyPressed: [ :c | self keyPressed: c ]
]

{ #category : #accessing }
SpCVTL >> cvtl [

	^ cvtl
]

{ #category : #accessing }
SpCVTL >> cvtl: anObject [

	cvtl := anObject
]

{ #category : #layout }
SpCVTL >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #menu expand: false;
		  add: toolBar expand: false;
		  add: #output;
		  yourself
]

{ #category : #constants }
SpCVTL >> defaultRandomSeed [

	^ 12345
]

{ #category : #private }
SpCVTL >> enterString: aString [

	aString lines do: [ :each | 
		inputQueue
			addAll: (each asArray collect: #asciiValue);
			add: Character cr asciiValue ].
	self resumeProcess
]

{ #category : #process }
SpCVTL >> executionLoop [

	[ 
	cvtl doOneCycle.
	(Delay forMilliseconds: 100) wait ] repeat
]

{ #category : #constants }
SpCVTL >> extension [

	^ 'vtl'
]

{ #category : #initialization }
SpCVTL >> fileMenu [

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
SpCVTL >> getAsciiValue [

	inputQueue notEmpty ifTrue: [ ^ inputQueue removeFirst ].
	process ifNil: [ ^ nil ].
	process suspend.
	inputQueue notEmpty ifTrue: [ ^ inputQueue removeFirst ].
	self error
]

{ #category : #initialization }
SpCVTL >> helpMenu [

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
SpCVTL >> initialize [

	cvtl := self newCVTL.
	self setupFor: cvtl.
	inputQueue := OrderedCollection new.
	super initialize
]

{ #category : #initialization }
SpCVTL >> initializePresenters [

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
SpCVTL >> initializeWindow: aWindow [

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
SpCVTL >> inputProgram [

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
SpCVTL >> inputQueue [

	^ inputQueue
]

{ #category : #accessing }
SpCVTL >> inputQueue: anObject [

	inputQueue := anObject
]

{ #category : #process }
SpCVTL >> keyPressed: anInteger [

	anInteger = 0 ifTrue: [ ^ self ].
	inputQueue add: anInteger.
	self resumeProcess
]

{ #category : #initialization }
SpCVTL >> languageMenu [

	| m classes |
	m := self newMenu.
	m addGroup: [ :grp | 
		classes := CVTL withAllSubclasses sort: [ :a :b | a name < b name ].
		classes do: [ :each | 
			grp addItem: [ :item | 
				item
					name: each name;
					action: [ self selectLanguage: each ] ] ] ].
	^ m
]

{ #category : #actions }
SpCVTL >> loadFile [

	| file |
	file := UIManager default
		        chooseExistingFileReference: 'Load program'
		        extensions: { self extension }
		        path: FileSystem workingDirectory.
	file ifNil: [ ^ self ].
	file isFile ifFalse: [ ^ self ].
	cvtl boundary: cvtl programAddress.
	self enterString: file contents.
	output takeKeyboardFocus
]

{ #category : #constants }
SpCVTL >> memorySize [

	^ 1024 * 32
]

{ #category : #'instance creation' }
SpCVTL >> newCVTL [

	^ CVTL new
]

{ #category : #'instance creation' }
SpCVTL >> newConsoleMorph [

	^ CVTLConsoleMorph new
]

{ #category : #'instance creation' }
SpCVTL >> newMemory: anInteger [

	^ CVTLMemory new
		  allocate: anInteger;
		  yourself
]

{ #category : #accessing }
SpCVTL >> output [

	^ output
]

{ #category : #accessing }
SpCVTL >> output: anObject [

	output := anObject
]

{ #category : #accessing }
SpCVTL >> process [

	^ process
]

{ #category : #accessing }
SpCVTL >> process: anObject [

	process := anObject
]

{ #category : #accessing }
SpCVTL >> putAsciiValue: anInteger [

	output morph putAsciiValue: anInteger
]

{ #category : #process }
SpCVTL >> resumeProcess [

	process ifNil: [ ^ self ].
	process isSuspended ifFalse: [ ^ self ].
	process resume
]

{ #category : #actions }
SpCVTL >> saveFile [

	| file dummyUI |
	file := UIManager default
		        chooseForSaveFileReference: 'Save program'
		        extensions: { self extension }
		        path: FileSystem workingDirectory.
	file ifNil: [ ^ self ].
	file := file withExtension: self extension.
	dummyUI := CVTLNonInteractiveUI new.
	cvtl ui in: [ :oldUI | 
		[ 
		cvtl ui: dummyUI.
		cvtl doList ] ensure: [ cvtl ui: oldUI ] ].
	file writeStreamDo: [ :stream | 
		stream nextPutAll: dummyUI outputString ].
	output takeKeyboardFocus
]

{ #category : #private }
SpCVTL >> selectLanguage: aClass [

	self stopProcess.
	cvtl := aClass new.
	self setupFor: cvtl.
	self startProcess
]

{ #category : #initialization }
SpCVTL >> setupFor: aCVTL [

	| memory |
	memory := self newMemory: self memorySize.
	aCVTL memory: memory.
	aCVTL memoryLimit: self memorySize.
	aCVTL boundary: aCVTL programAddress.
	memory wordAt: aCVTL randomAddress put: self defaultRandomSeed
]

{ #category : #initialization }
SpCVTL >> setupMenu [

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
SpCVTL >> startProcess [

	self stopProcess.
	cvtl ui: self.
	process := [ 
	           self executionLoop.
	           process := nil ] fork
]

{ #category : #process }
SpCVTL >> stopProcess [

	process ifNil: [ ^ self ].
	process terminate.
	process := nil
]
