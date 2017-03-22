REBAR = ./rebar3

.PHONY: test doc type init clean

test:
	$(REBAR) ct

doc:
	$(REBAR) edoc; mv doc docs

type:
	$(REBAR) dialyzer

init:
	chmod u+x $(REBAR)

clean:
	$(REBAR) clean
	rm -rf _build
