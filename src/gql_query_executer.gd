extends Node

class_name GQLQueryExecuter

signal graphql_response

var endpoint: String
var query: GQLQuery
var use_ssl: bool
var query_cached: String

var headers = ["Content-Type: application/json"]
var request : HTTPRequest


func _init(_endpoint:String, _use_ssl: bool, _query: GQLQuery):
	endpoint = _endpoint
	query = _query
	use_ssl = _use_ssl

func _ready():
	request = HTTPRequest.new()
	request.connect('request_completed', self, 'request_completed')
	add_child(request)

func request_completed( result:int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	print("Request completed:", result, ",",  response_code)
	if response_code!=200:
		print("Query:"+query_cached)
		print("Response:"+body.get_string_from_utf8())
	var json = JSON.parse(body.get_string_from_utf8())
	emit_signal('graphql_response', json.result)

func run(variables: Dictionary):
	assert(request!=null, 'You should add this node to the childs')
	if ! query_cached:
		query_cached = query.serialize()
	var data_to_send = {
		"query": query_cached,
		"variables": variables,
	}
	print("h:", headers, "use_ssl:", use_ssl)
	var err=request.request(endpoint, headers, false, HTTPClient.METHOD_POST, JSON.print(data_to_send))
	print("Request to: ", endpoint, " return: ", err)
