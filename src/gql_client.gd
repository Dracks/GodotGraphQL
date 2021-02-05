extends Node

class_name GQLClient

var host: String
var endpoint: String
var use_ssl: bool
var headers:= {
	"Content-Type": "application/json"
}


func set_endpoint(is_secure: bool, _host: String, port: int, path: String):
	host = "http://"
	use_ssl = is_secure
	if is_secure:
		host = "https://"
	host += _host
	if port!=0:
		host += ":{0}/".format([port])
	endpoint = host+path

func add_header(name:String, value: String):
	headers[name]=value


func generate_headers(head: Dictionary)-> PoolStringArray:
	var new_headers := {}
	for key in headers.keys():
		new_headers[key] = headers[key]

	for key in head.keys():
		new_headers[key] = head[key]

	var headers_list:= PoolStringArray()
	for key in new_headers.keys():
		headers_list.push_back(key+": "+new_headers[key])

	return headers_list
