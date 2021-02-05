extends Node

class_name GQLQueryExecuter

signal graphql_response

export(String, MULTILINE) var query: String

var headers := {}
var request : HTTPRequest

func _init(_query: String=""):
	print(_query, query)
	if len(_query)>0:
		query = _query

func _ready():
	request = HTTPRequest.new()
	request.connect('request_completed', self, 'request_completed')
	add_child(request)

func request_completed( result:int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	print("Request completed:", result, ",",  response_code)
	if response_code!=200:
		print("Query:"+query)
		print("Response:"+body.get_string_from_utf8())
	var json = JSON.parse(body.get_string_from_utf8())
	emit_signal('graphql_response', json.result)

func run(client: GQLClient, variables: Dictionary):
	assert(request!=null, 'You should add this node to the childs')
	var use_ssl = client.use_ssl
	var data_to_send = {
		"query": query,
		"variables": variables,
	}
	print("h:", headers, "use_ssl:", use_ssl)
	var headers_list = client.generate_headers(headers)
	var err=request.request(client.endpoint, headers_list, false, HTTPClient.METHOD_POST, JSON.print(data_to_send))
	print("Request to: ", client.endpoint, " return: ", err)
