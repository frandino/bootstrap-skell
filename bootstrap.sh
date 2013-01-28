#!/usr/bin/env bash

echo "Setting up your environment..."

red() {
  echo -e "\033[31m $1\033[0m"
}

green() {
  echo -e "\033[0;32m$1\033[0m"
}

white() {
  echo -e "\033[0;37m$1\033[0m"
}

command_exists() {
  command -v "$1" &>/dev/null
}

test_dependency() {
  if command_exists "$1"; then
    green "  ✔  $2 is already installed."
  else
    exec >&2
    red "   ✖  You need to install $2.\c"
    if [[ -n "$3" ]]; then
      white "\n     $3\n"
    else
      echo " If you use Homebrew, you can run:"
      white "     brew install $2\n"
    fi
    return 1
  fi
}

check_ruby() {
  if ruby -v | grep -q "$1"; then
    green "  ✔  Ruby $1 is already installed."
  else
    red "  ✖  Ruby 1.9.3 is not installed. Please install it."
    return 1
  fi
}

(
  set -e
  test_dependency "bundle" "Bundler" "gem install bundler"
  check_ruby "1.9.3"
)

if (( $? != 0 )); then
  exit $?
fi

echo "Installing gems"
bundle config --local path vendor > /dev/null 2>&1
bundle config --local bin b > /dev/null 2>&1
bundle config --local disable_shared_gems 1 > /dev/null 2>&1
bundle check > /dev/null 2>&1 || bundle install --quiet

cp config/database.sample.yml config/database.yml &&
b/rake db:setup &&

echo "Done"
