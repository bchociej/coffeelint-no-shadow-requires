nameof = (node) -> node?.constructor?.name

getRequiredVar = (node) ->
	{variable, value} = node
	[lhs, rhs] = [variable, value]

	return unless nameof(node) is 'Assign'
	return if node.context is 'object'
	return unless nameof(lhs?.base) is 'Literal'
	return if lhs?.properties?.length > 0
	return unless nameof(rhs) is 'Call'
	return unless nameof(rhs.variable) is 'Value'
	return unless rhs.variable.base.value is 'require'

	return lhs.base.value

getAssignedVar = (node) ->
	{variable, value} = node
	[lhs, rhs] = [variable, value]

	return unless nameof(node) is 'Assign'
	return if node.context is 'object'
	return unless nameof(lhs?.base) is 'Literal'
	return if lhs?.properties?.length > 0

	return lhs.base.value

getParam = (node) ->
	name = node.name

	return unless nameof(node) is 'Param'
	return unless nameof(name) is 'Literal'

	return name.value

module.exports = class NoRedef
	rule:
		name: 'no_shadow_requires'
		level: 'warn'
		message: 'Redefined a variable previously defined by a require() call'
		description: 'Make sure you don\'t shadow a require()d variable'

	lintAST: (node, @astApi) ->
		@topRequireNodes = {}

		for expr in node.expressions
			required = getRequiredVar expr

			if required?
				@topRequireNodes[required] = expr

		@checkNode node

		return

	generateError: (node, name, type) ->
		@astApi.createError
			lineNumber: node.locationData.first_line + 1
			message:
				if type is 'variable'
					"Redefined/shadowed a top-level require() variable: '#{name}'"
				else
					"Function parameter shadows a top-level require(): '#{name}'"

	checkNode: (node) ->
		assigned = getAssignedVar node
		param = getParam node

		if assigned? and @topRequireNodes[assigned]?
			unless node is @topRequireNodes[assigned]
				@errors.push @generateError(node, assigned, 'variable')

		if param? and @topRequireNodes[param]?
			@errors.push @generateError(node, param, 'parameter')

		node.eachChild (node) =>
			@checkNode(node) if node?
