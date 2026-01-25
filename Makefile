.PHONY: test doc

test:
	bundle exec rspec

doc:
	bundle exec rspec --format documentation
