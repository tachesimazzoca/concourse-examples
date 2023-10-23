.PHONY: plan
plan:
	@chef-client -z -W -N localhost -j localhost.json

.PHONY: apply 
apply:
	@chef-client -z -N localhost -j localhost.json
