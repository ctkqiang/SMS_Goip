compile:
	clear
	mix deps.get
	mix compile
	iex -S mix
 
clean:
	mix deps.clean --all
	rm -r deps
	rm -r _build/dev/lib
	clear

unit:
	clear
	mix test test/sms_test.exs
