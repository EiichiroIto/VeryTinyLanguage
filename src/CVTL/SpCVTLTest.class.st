"
A SpCVTLTest is a test class for testing the behavior of SpCVTL
"
Class {
	#name : #SpCVTLTest,
	#superclass : #TestCase,
	#category : #'CVTL-Tests'
}

{ #category : #'instance creation' }
SpCVTLTest >> newApp [

	^ SpCVTL new
]

{ #category : #tests }
SpCVTLTest >> testGetAsciiValue [

	| app process x |
	app := self newApp.
	self assert: app inputQueue isEmpty.
	app inputQueue add: 123.
	x := nil.
	process := [ x := app getAsciiValue ] newProcess.
	process suspend.
	app process: process.
	self assert: x isNil.
	process resume.
	(Delay forMilliseconds: 50) wait.
	self assert: x equals: 123.
	x := nil.
	process := [ x := app getAsciiValue ] newProcess.
	process suspend.
	app process: process.
	self assert: x isNil.
	process resume.
	(Delay forMilliseconds: 100) wait.
	self assert: x isNil.
	self assert: process isSuspended.
	process terminate
]

{ #category : #tests }
SpCVTLTest >> testKeyPressed [

	| app process x |
	app := self newApp.
	self assert: app inputQueue isEmpty.
	x := nil.
	process := [ x := app getAsciiValue ] newProcess.
	process suspend.
	app process: process.
	self assert: x isNil.
	process resume.
	(Delay forMilliseconds: 50) wait.
	self assert: x isNil.
	self assert: process isSuspended.
	app keyPressed: 456.
	(Delay forMilliseconds: 50) wait.
	self assert: x equals: 456.
	self assert: process isTerminated.
	process terminate
]
