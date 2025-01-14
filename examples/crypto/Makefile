VERFILES=cca2.fst #sha1.fst mac.fst sig.fst padding.fst mac3.fst # encrypt3.fst formatting.fst rpc.fst
MITLS=../../../mitls-fstar

ifeq ($(OS),Windows_NT)
#CC = i686-w64-mingw32-gcc.exe
CC = flexlink -chain mingw -v -v -exe -lgdi32
# flexlink is needed to link in	/cygdrive/c/OCaml/bin/flexdll_initer_mingw.o /cygdrive/c/OCaml/bin/flexdll_mingw.o
#LIB = /cygdrive/c/msys32/usr/lib
LIB = $(FSTAR_HOME)/../openssl-1.0.1p
else
CC = gcc-5
LIB = /usr/lib #place to look for libcrypto.a
endif

include ../Makefile.include
all: .all.crypto.ver merkle_tree # rpc acls-cap

.all.crypto.ver: $(VERFILES)
	$(FSTAR) --z3timeout 10 --prims ../../lib/prims.fst --admit_fsi Seq $(addprefix $(FSTAR_HOME)/lib/, string.fst list.fst ext.fst classical.fst \
	set.fsi set.fst \
	heap.fst st.fst \
	seq.fsi seqproperties.fst ) $^


mac:
	$(FSTAR) $(FSTAR_HOME)/lib/partialmap.fst $(FSTAR_HOME)/lib/st.fst sha1.fst mac.fst

merkle_tree:
	$(FSTAR) $(FSTAR_HOME)/lib/list.fst $(FSTAR_HOME)/lib/constr.fst merkle_tree.fst

acls-cap: sha1.fst mac.fst ../security/acls2.fst acls-cap.fst
	$(FSTAR) --z3timeout 10 --prims ../../lib/prims.fst --admit_fsi Seq $(addprefix $(FSTAR_HOME)/lib/, string.fst list.fst ext.fst classical.fst \
	set.fsi set.fst \
	heap.fst st.fst \
	seq.fsi seqproperties.fst ) $^


rpc: formatting.fst sha1.fst mac.fst rpc.fst
	$(FSTAR) --z3timeout 10 --prims ../../lib/prims.fst --admit_fsi Seq  \
          $(addprefix $(FSTAR_HOME)/lib/, string.fst io.fst list.fst ext.fst classical.fst \
					set.fsi set.fst \
					heap.fst st.fst \
					seq.fsi seqproperties.fst )  \
					$(addprefix $(FSTAR_HOME)/contrib/,  Platform/fst/Bytes.fst CoreCrypto/fst/CoreCrypto.fst) \
					sha1.fst mac.fst formatting.fst rpc.fst


mllibs:
	make -C $(FSTAR_HOME)/contrib/Platform/ml clean all
	make -C $(FSTAR_HOME)/contrib/CoreCrypto/ml clean all


rpc-extract:
	$(FSTAR) --codegen-lib Platform --codegen-lib CoreCrypto --codegen OCaml \
          $(addprefix $(FSTAR_HOME)/lib/, string.fst io.fst list.fst ext.fst classical.fst \
					set.fsi set.fst \
					heap.fst st.fst \
					seq.fst seqproperties.fst ) \
					$(addprefix $(FSTAR_HOME)/contrib/,  Platform/fst/Bytes.fst CoreCrypto/fst/CoreCrypto.fst) \
					sha1.fst mac.fst formatting.fst rpc.fst  --debug high
	ocamlfind ocamlopt -cc "$(CC)" -cclib -L$(LIB) -cclib -lcrypto -o rpc.exe -package batteries -linkpkg -g -thread -I $(FSTAR_HOME)/contrib/Platform/ml -I $(FSTAR_HOME)/contrib/CoreCrypto/ml -I \
	        $(FSTAR_HOME)/src/ocaml-output/ \
					$(FSTAR_HOME)/src/ocaml-output/support.cmx \
					$(addprefix $(FSTAR_HOME)/contrib/,  Platform/ml/platform.cmx CoreCrypto/ml/CoreCrypto.cmxa) \
					Seq.ml SeqProperties.ml SHA1.ml MAC.ml Formatting.ml RPC.ml

cnt-protocol: cnt-format.fst cnt-format.fsi cnt-mac.fst cnt-protocol.fst
	$(FSTAR) --admit_fsi Set $(addprefix $(FSTAR_HOME)/lib/, list.fst string.fst partialmap.fst ) cnt-format-deprecated.fst
	$(FSTAR) --z3timeout 10 --prims ../../lib/prims.fst --admit_fsi Seq --max_fuel 4 --initial_fuel 0 --max_ifuel 2 --initial_ifuel 1 \
          $(addprefix $(FSTAR_HOME)/lib/, string.fst list.fst ext.fst classical.fst \
					set.fsi set.fst \
					heap.fst st.fst \
					seq.fsi seqproperties.fst ) cnt-format.fst cnt-mac.fst cnt-protocol.fst

clean:
	rm -fr rpc *.ml *.cmi *.cmx *.o *~
