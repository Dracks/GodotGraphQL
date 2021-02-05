class_name GQLHelper

class Abstract:
	var name: String
	var props_list: Array = []
	var args_list: Dictionary

	func _init(_name: String):
		name = _name

	func set_args(_args: Dictionary):
		args_list = _args
		return self

	func set_props(_props: Array):
		props_list = _props
		return self

	func add_prop(_prop):
		props_list.append(_prop)
		return self

	func _serialize_args()->String:
		return ""

	func serialize():
		var query = name
		if args_list and args_list.size()>0:
			query += self._serialize_args()

		if props_list.size()>0:
			query += " {\n"
			for prop in props_list:
				if typeof(prop)==TYPE_STRING:
					query +=prop+"\n"
				else:
					query +=prop.serialize()+"\n"
			query +="}"
		return query

class Field:
	extends Abstract

	func _init(name:String).(name):
		pass

	func _serialize_args()->String:
		var query = " ("
		var sep = ""
		for variable in args_list.keys():
			query +=sep+args_list[variable]+": $"+variable
			sep = ", "
		return query + ")"


class AbstractQuery:
	extends Abstract

	func _init(name:String).(name):
		pass

	func _serialize_args()->String:
		var query = " ("
		var sep = "$"
		for variable in self.args_list.keys():
			query +=sep+variable+": "+self.args_list[variable]
			sep = ", $"
		return query + ")"


class Query:
	extends AbstractQuery

	func _init(name:String).("query "+name):
		pass

class Mutation:
	extends AbstractQuery

	func _init(name:String).("mutation "+name):
		pass

