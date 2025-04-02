class_name GQLQuery

var name: String
var props_list: Array = []
var args_list: Dictionary = {}

func _init(_name: String):
	name = _name

func set_args_v2(_args: Dictionary) -> GQLQuery:
	args_list = _args
	return self

func set_args(_args: Dictionary) -> GQLQuery:
	print("Deprecated set_args, please use set_args_v2 inverting the keys and values of the dict")
	var new_args_list = {}
	for variable in _args.keys():
		var arg = _args[variable]
		new_args_list[arg] = variable
	self.args_list = new_args_list
	return self


func set_props(_props: Array) -> GQLQuery:
	props_list = _props
	return self

func add_prop(_prop) -> GQLQuery:
	props_list.append(_prop)
	return self

func _serialize_args()->String:
	var query = " ("
	var sep = ""
	for arg in args_list.keys():
		var variable = args_list[arg]
		if variable == "$":
			variable = arg
		query +=sep+arg+": $"+variable
		sep = ", "
	return query + ")"


func serialize() -> String:
	var query = name
	if args_list.size()>0:
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
