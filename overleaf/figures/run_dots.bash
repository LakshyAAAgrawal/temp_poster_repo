#!/usr/bin/env bash
cd figures/
cd dag_dots
for f in *.dot; do   docker run --rm -i nshine/dot dot -Gsize=8,8\! -Gratio=fill -Tpdf < "$f" > "${f%.dot}.pdf"; done
cd ..
cd manual_dots
for f in *.dot; do   docker run --rm -i nshine/dot dot -Tpdf < "$f" > "${f%.dot}.pdf"; done
cd ..
cd ..