all: stutest.out

clean:
	rm -f *.out out.txt
	ls

move_files: spec_helper.rb parser_spec.rb
	mkdir spec
	cp spec_helper.rb spec/spec_helper.rb
	cp parser_spec.rb spec/parser_spec.rb

bundle: Gemfile
	bundle

stutest.out: move_files bundle parser2.rb
	echo 'Running tests. See spec/parser_spec.rb for test details:'
	rspec > stutest.out
	cat stutest.out
