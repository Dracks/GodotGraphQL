extends GutTest

func test_simple_prop():
	var subject = GQLQuery.new("prop1")

	assert_eq(subject.serialize(), "prop1")

func test_prop_with_arguments():
	var subject = GQLQuery.new('prop2').set_args({"variable1":"arg1", "variable2":"arg2"})

	assert_eq(subject.serialize(), "prop2 (arg1: $variable1, arg2: $variable2)")


func test_complex_with_subqueries():
	var subquery = GQLQuery.new('subprop').set_args({"variable3":"arg3"})
	var subject = GQLQuery.new('prop3').set_props([
		"some_prop",
		subquery
	])

	assert_eq(subject.serialize(), "prop3 {\nsome_prop\nsubprop (arg3: $variable3)\n}")

func test_set_args_v2():
	var subject = GQLQuery.new('subject').set_args_v2({"input": "variable"})

	assert_eq(subject.serialize(), "subject (input: $variable)")

func test_more_complex_reusing_names():
	var subsubquery = GQLQuery.new("subsubprop").set_props([
		"prop1"
	])
	var subquery = GQLQuery.new("subprop").set_args_v2({"variable": "$"}).set_props([
		subsubquery,
		"extra_prop"
	])

	var subject = GQLQuery.new('subject').set_props([subquery])

	assert_eq(subject.serialize(), "subject {\nsubprop (variable: $variable) {\nsubsubprop {\nprop1\n}\nextra_prop\n}\n}")
