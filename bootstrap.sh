#!/usr/bin/env bash

echo "Setting up your environment..."

red="\033[31m"
green="\033[0;32m"
white="\033[0;37m"
reset="\033[0m"

error=0
function test_dependency() {
  if [ ! $(which $1 2> /dev/null) ]; then
    echo -e "$red  ✖  You need to install $2.\c"
    if [ -n "$3" ]; then
      echo -e "$white\n     $3\n"
    else
      echo " If you use Homebrew, you can run:"
      echo -e "$white     brew install $2\n"
    fi
    error=1
  else
    echo -e "$green  ✔  $2 is already installed."
  fi
  echo -e "$reset\c"
}

#
# Check for Ruby 1.9.3
#
rbversion=$(ruby -v | grep -c "1.9.3")
if [ $rbversion -ne 1 ]; then
  echo -e "$red  ✖  Ruby 1.9.3 is not installed. Please install it.$reset"
  error=1
else
  echo -e "$green  ✔  Ruby 1.9.3 is already installed.$reset"
fi

test_dependency "bundle" "Bundler" "gem install bundler"

if [ $error -ne 0 ]; then
  exit 1
fi

echo "Installing gems"
bundle install --quiet --binstubs=b --path vendor &&
cp config/database.sample.yml config/database.yml &&
b/rake db:setup &&

echo "Done"
