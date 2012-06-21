#!/bin/sh

echo "Setting up your environment..."

red="\033[31m"
green="\033[0;32m"
white="\033[0;37m"
reset="\033[0m"

error=0
function test_dependency() {
  if [ ! $(which $1) ]; then
    echo "$red  ✖  You need to install $2.\c"
    if [ -n "$3" ]; then
      echo "$white\n     $3\n"
    else
      echo " If you use Homebrew, you can run:"
      echo "$white     brew install $2\n"
    fi
    error=1
  else
    echo "$green  ✔  $2 is already installed."
  fi
  echo "$reset\c"
}

#
# Check for Ruby Enterprise Edition
#
rbversion=$(ruby -v | grep -c "Ruby Enterprise Edition")
if [ $rbversion -ne 1 ]; then
  echo "$red  ✖  Ruby Enterprise Edition is not installed. Please install it.$reset"
  error=1
else
  echo "$green  ✔  Ruby Enterprise Edition is already installed.$reset"
fi

test_dependency "bundle" "Bundler" "gem install bundler"

if [ $error -ne 0 ]; then
  exit 1
fi

echo "Done"
