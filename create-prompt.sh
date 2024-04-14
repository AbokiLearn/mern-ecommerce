#!/bin/bash

echo > prompt.md

find . -type f \
  ! -name 'SECURITY.md' \
  ! -name 'package-lock.json' \
  ! -name 'LICENSE' \
  ! -name 'content-plan-client.md' \
  ! -name 'compose.yml' \
  ! -name 'bun.lockb' \
  ! -name '.prettierignore' \
  ! -name '.gitignore' \
  ! -name '.env' \
  ! -path './server/*' \
  ! -path './node_modules/*' \
  ! -path './data/*' \
  ! -path './.vscode/*' \
  ! -path './.github/*' \
  ! -name '.babelrc' \
  ! -name 'vercel.json' \
  ! -path './client/public/images/*' \
  ! -path './.git/*' \
  ! -name 'prompt.md' | while read file; do
    echo "<file name=\"${file}\" format=\"$(basename "${file##*.}")\">" >> prompt.md
    cat "$file" >> prompt.md
    echo "</file>" >> prompt.md
done

