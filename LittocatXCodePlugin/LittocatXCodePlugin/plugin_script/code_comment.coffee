class TestStorage
	constructor: (@string,@selecteRange,@fileName)->


class TextCommand
	constructor: (@name)->

	run:(textStorage)->
		null

class CodeCommentCommand extends Animal

	run: (textStorage)->
		null