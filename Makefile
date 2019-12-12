
main:
	ocamlbuild -pkg str ftest.native

format:
	ocp-indent --inplace src/*

clean:
	rm -rf _build/
	rm ftest.native
