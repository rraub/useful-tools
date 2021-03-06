#!/bin/sh
# To generate SHA1 checksums of a directory and compare the checksums with the 
# checksums from the last run of this script. 
#  It takes two optional arguments 
#   1 - the directory to checksum
#   2 - the directory to store the checksums in


CUR_EPOC_TIME=$(date +%s)
CHECKSUM_FILENAME="checksums.txt"

# if first argument is provided then we'll use it, otherwise lets use the current directory
if [ -z $1 ]; then
  DIR_TO_CHECK="."
else
  DIR_TO_CHECK="$1"
fi

# The second argument is the directory to store checksums in 
if [ -z $2 ]; then
  DIR_TO_STORE_CHECKSUMS=""
else
  DIR_TO_STORE_CHECKSUMS="$1"
fi


# lets check to see if the sha1sum utility is available
if hash sha1sum 2>/dev/null; then
  # sha1sum is defined
  SHA_BIN="sha1sum"
else
  # sha1sum is NOT defined, lets fall back to shasum
  SHA_BIN="shasum"
fi

# if we can read from checksums
if [ -r $CHECKSUM_FILENAME ]; then
  mv "$DIR_TO_STORE_CHECKSUMS$CHECKSUM_FILENAME" "$DIR_TO_STORE_CHECKSUMS$CHECKSUM_FILENAME-$CUR_EPOC_TIME"
fi

# find the last checksum file to compare against (while suppressing errors) this relies on the epoc time always increasing
LAST_CHECKSUM_FILE=$(ls -1 "$DIR_TO_STORE_CHECKSUMS$CHECKSUM_FILENAME"-* 2>/dev/null | sort -r | head -n 1)

# compute checksums
find $DIR_TO_CHECK -type f -print0 | xargs -0 "$SHA_BIN" > "$DIR_TO_STORE_CHECKSUMS$CHECKSUM_FILENAME-$CUR_EPOC_TIME"

# if this is the first time running this checksum..
if [ "x$LAST_CHECKSUM_FILE" = "x" ]; then
  echo " no checksum file found to compare against, this must be the first time you've run this script"
else
  # do the comparison 
  diff $LAST_CHECKSUM_FILE "$DIR_TO_STORE_CHECKSUMS$CHECKSUM_FILENAME-$CUR_EPOC_TIME"
fi
