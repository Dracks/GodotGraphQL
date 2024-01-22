extends Node

class_name GQLClient

var endpoint: String
var use_ssl: bool
var websocket_endpoint: String


class AbstractQuery:
	extends GQLQuery

	func _init(name:String):
		super(name);

	func _serialize_args()->String:
		var query = " ("
		var sep = "$"
		for variable in args_list.keys():
			query +=sep+variable+": "+args_list[variable]
			sep = ", $"
		return query + ")"


class Query:
	extends AbstractQuery

	func _init(name:String):
		super("query "+name)

class Mutation:
	extends AbstractQuery

	func _init(name:String):
		super("mutation "+name)
		
class Subscription:
	extends AbstractQuery
	
	func _init(name: String):
		super("subscription "+name)

func set_endpoint(is_secure: bool, host: String, port: int, path: String):
	endpoint = "http://"
	websocket_endpoint = "ws://"
	use_ssl = is_secure
	if is_secure:
		endpoint = "https://"
		websocket_endpoint = "wss://"
	endpoint += host
	websocket_endpoint += host
	if port!=0:
		endpoint += ":{0}".format([port])
		websocket_endpoint +=":{0}".format([port])
	endpoint += path
	websocket_endpoint += path


func query(name:String, args: Dictionary, query: GQLQuery):
	var _query = Query.new(name).set_args(args).add_prop(query)
	return GQLQueryExecuter.new(endpoint, use_ssl, _query)

func mutation(name:String, args: Dictionary, query: GQLQuery):
	var _query = Mutation.new(name).set_args(args).add_prop(query)
	return GQLQueryExecuter.new(endpoint, use_ssl, _query)

func subscribe(name: String, args: Dictionary, query: GQLQuery):
	var _query = Subscription.new(name).set_args(args).add_prop(query)
	return GQLQuerySubscriber.new(websocket_endpoint, _query)

func raw(query:String):
	return GQLQueryExecuter.new(endpoint, use_ssl, Query.new(query))
