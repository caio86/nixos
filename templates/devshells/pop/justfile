default:
  @just --list

[no-cd]
build src="main.cpp":
  # Building
  g++ {{src}} -o output --std=c++17 -O3 -DLOCAL

[no-cd]
_run input="input.txt":
  # Running with input: {{input}}
  ./output <{{input}} | tee {{input}}_out

[no-cd]
run +inputs="input.txt": build
  #!/usr/bin/env bash
  set -euo pipefail

  for file in {{inputs}}; do
    just _run $file
  done

[no-cd]
watch +inputs="input.txt":
  watchexec -e "cpp" -r "just run {{inputs}}"
