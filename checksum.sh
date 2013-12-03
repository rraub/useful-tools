#!/bin/sh
# To generate SHA1 checksums of a directory and compare the checksums with the 
# checksums from the last run of this script. It takes one argument

CUR_EPOC_TIME=$(date -j -f "%a %b %d %T %Z %Y" "`date`" "+%s")
CHECKSUM_FILENAME="checksums.txt"

# if an argument is provided then we'll use it, otherwise lets use the current directory
if [ -z $1 ]; then
  DIR_TO_CHECK="."
else
  DIR_TO_CHECK="$1"
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
  mv "$CHECKSUM_FILENAME" "$CHECKSUM_FILENAME-$CUR_EPOC_TIME"
fi

# find the last checksum file to compare against 
LAST_CHECKSUM_FILE=$(ls -1 "$CHECKSUM_FILENAME"-* | sort -r | head -n 1)

# for now assume the current dir
find $DIR_TO_CHECK -type f -print0  | xargs -0 "$SHA_BIN" > "$CHECKSUM_FILENAME-$CUR_EPOC_TIME"

# do the comparison 
diff $LAST_CHECKSUM_FILE "$CHECKSUM_FILENAME-$CUR_EPOC_TIME"
