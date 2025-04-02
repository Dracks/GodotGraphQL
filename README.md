# Godot GraphQLClient Addon

## Prerequisits
You need to have GUT in your project.
See https://gut.readthedocs.io/en/latest/Install.html

## Instalation
1. download the contents (or clone) and put inside $PROJECT/addons
2. Create a class extending GQLClient
3. Implement in a _ready function or in the same _init to configure it calling to set_endpoint(is_secure, host, port, path)
4. Add this class as an autoload of your godot project.

## Usage
This library uses his own objects to create the query. But provide also a raw argument to call with a string.

1. create some graphql query:
```gdscript
var query =GQLQuery.new("someProp").set_args_v2({"arg":"variable"}).set_props([
	"otherProp",
	GQLQuery.new("moreComplexProp")
])
```

2. Call to your singleton to the query method and add it to your node_tree:
```gdscript
var my_query_executer = ServerConfigInstance.query("NameOfTheQuery", {"variable":"HisType"}, query)
```

3. Connect to graphql_response signal to retrieve the data
4. Execute the run method with the variables as args
```gdscript
my_query_executor.run({"variable":42})
```

You can see the [sample project](https://github.com/Dracks/godot-gql-test)

## Features
* Tested with a django-graphene server
* Do queries and mutations
* gql_query tested using [gut](https://github.com/bitwes/Gut)


## Documentation
### GQLQuery samples
The sample of use in the usage will generate something like this:
```graphql
someProp(arg:$variable){
	otherProp
	moreComplexProp
}
```

As you can see there is no query information or mutation. The query or mutation is added when you call to client.query or client.mutation. The query generated in the point usage 4 is the following:
```graphql
query NameOfTheQuery(variable: HisType){
	someProp(arg:$variable){
		otherProp
		moreComplexProp
	}
}
```
Adding the variable of variable to 42

### Writing the graphql with samples
1. Query a field with variables
```gdscript
var gqlClient : GqlClient = get_node('/root/GqlClient')
var subject = GQLQuery.new("prop").set_args_v2({"argument": "input"}).set_props(["sample"])
var executor = gqlClient.query("queryName", {"input": "String" }, subject)
```

Will generate
```Gql
query queryName ($input: String) {
   prop(argument: $input){
	   sample
   }
}
```

2. Using variable shortcut, when the argument name is the same as the variable, we can use a $ to automatically match them
```gdscript
var gqlClient : GqlClient = get_node('/root/GqlClient')
var subject = GQLQuery.new("prop").set_args_v2({"argument": "$"}).set_props(["sample"])
var executor = gqlClient.query("queryName", {"argument": "String" }, subject)
```

Will generate
```Gql
query queryName ($argument: String) {
   prop(argument: $argument){
	   sample
   }
}
```
