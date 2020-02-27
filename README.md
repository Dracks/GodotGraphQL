# Godot GraphQLClient Addon
## Instalation
1. download the contents (or clone) and put inside $PROJECT/addons
2. Create a class extending GQLClient
3. Implement in a _ready function or in the same _init to configure it calling to set_endpoint(is_secure, host, port, path)
4. Add this class as an autoload of your godot project.

## Usage
This library uses his own objects to create the query. But provide also a raw argument to call with a string.

1. create some graphql query:
```
var query =GQLQuery.new("someProp").set_args({"variable":"arg"}).set_props([
	"otherProp",
	GQLQuery.new("moreComplexProp")
])
```

2. Call to your singleton to the query method and add it to your node_tree:
```
var my_query_executer = ServerConfigInstance.query("NameOfTheQuery", {"SomeVariables":"HisType"}, query)
```

3. Connect to graphql_response signal to retrieve the data
4. Execute the run method with the variables as args
```
my_query_executor.run({"SomeVariables":42})
```

## Features
* Tested with a django-graphene server
* Do queries and mutations
* gql_query tested using [gut](https://github.com/bitwes/Gut)


## Documentation
### GQLQuery samples
The sample of use in the usage will generate something like this:
```
someProp(arg:$variable){
	otherProp
	moreComplexProp
}
```

As you can see there is no query information or mutation. The query or mutation is added when you call to client.query or client.mutation. The query generated in the point usage 4 is the following:
```
query NameOfTheQuery(SomeVariable: HisType){
	someProp(arg:$variable){
		otherProp
		moreComplexProp
	}
}
```
Adding the variable of SomeVariable to 42

