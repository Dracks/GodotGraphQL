class_name GQLQuery

var name: String
var props_list: Array = []
var args_list: Dictionary = {}

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
	var query = " ("
	var sep = ""
	for variable in args_list.keys():
		query +=sep+args_list[variable]+": $"+variable
		sep = ", "
	return query + ")"

func _serialize_args_usage() -> String:
	var query = "("
	var sep = ""
	for variable in args_list.keys():
		query += sep + variable + ": $" + variable
		sep = ", "
	return query + ")"

func serialize() -> String:
	var query = name
	if args_list.size() > 0:
		query += " " + _serialize_args()

	if props_list.size() > 0:
		query += " {\n"
		for prop in props_list:
			if typeof(prop) == TYPE_STRING:
				query += prop + "\n"
			else:
				query += prop.name
				if prop.args_list.size() > 0:
					query += " " + prop._serialize_args_usage()
				query += " {\n"
				for p in prop.props_list:
					query += p + "\n"
				query += "}\n"
		query += "}"
	return query
