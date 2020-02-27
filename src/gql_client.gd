extends Node

class_name GQLClient

var endpoint: String
var use_ssl: bool


class AbstractQuery:
	extends GQLQuery

	func _init(name:String).(name):
		pass

	func _serialize_args()->String:
		var query = " ("
		var sep = "$"
		for variable in args_list.keys():
			query +=sep+variable+": "+args_list[variable]
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

func set_endpoint(is_secure: bool, host: String, port: int, path: String):
	endpoint = "http://"
	use_ssl = is_secure
	if is_secure:
		endpoint = "https://"
	endpoint += host
	if port!=0:
		endpoint += ":{0}".format([port])
	endpoint += path


func query(name:String, args: Dictionary, query: GQLQuery):
	var _query = Query.new(name).set_args(args).add_prop(query)
	return GQLQueryExecuter.new(endpoint, use_ssl, _query)

func mutation(name:String, args: Dictionary, query: GQLQuery):
	var _query = Mutation.new(name).set_args(args).add_prop(query)
	return GQLQueryExecuter.new(endpoint, use_ssl, _query)


func raw(query:String):
	return GQLQueryExecuter.new(endpoint, use_ssl, Query.new(query))
