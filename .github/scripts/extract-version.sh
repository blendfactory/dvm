#!/usr/bin/env bash

content=$(cat pubspec.yaml)
version=$(awk '/version: /{print $2}' <<<"$content")
echo "version=$version" >> $GITHUB_OUTPUT
