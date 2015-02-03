all: stutest.out

clean:
	rm -f *.out out.txt
	ls

Gemfile.lock: Gemfile
	bundle

parse_file: parse_file.rb parser2.rb Gemfile.lock
	ruby ./parse_file.rb $(FILE)

stutest.out: clean Gemfile.lock parser2.rb
	echo 'Running tests. See spec/parser_spec.rb for test details:'
	rspec > stutest.out
	cat stutest.out
