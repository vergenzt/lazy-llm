#!/usr/bin/env bash
set -euo pipefail  # https://sipb.mit.edu/doc/safe-shell/
set -x

git ls-files ":!$0" | xargs perl -pi -e 's#ponytail:#tech debt:#g'

# rename self-references in content
git ls-files ":!$0" | xargs perl -pi -e 's#vergenzt/lazy-llm#vergenzt/lazy-llm#g'
git ls-files ":!$0" | xargs perl -pi -e 's#\bPonytail\b#Lazy LLM#g'
git ls-files ":!$0" | xargs perl -pi -e 's#Ponytail#LazyLLM#g'
git ls-files ":!$0" | xargs perl -pi -e 's#ponytail#lazy#g'

# ...and in filenames
find . -name '*ponytail*' | sed 'p;s/ponytail/lazy/g' | xargs -n2 mv
