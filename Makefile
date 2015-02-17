all: stutest.out

install:
	git clone git@github.com:Woffendm/cs480.git
	git fetch
	git checkout -b m3 milestone3

clean:
	rm -f *.out out.txt
	ls

Gemfile.lock: Gemfile
	bundle

parse_file: parse_file.rb parser.rb Gemfile.lock scanner.rb tokens.rb
	ruby ./parse_file.rb $(FILE)

scan_file: scan_file.rb scanner.rb Gemfile.lock tokens.rb
	ruby ./scan_file.rb $(FILE)

stutest.out: clean Gemfile.lock parser.rb scanner.rb tokens.rb
	echo 'Running tests. See spec/parser_spec.rb for test details:'
	rspec > stutest.out
	cat stutest.out
