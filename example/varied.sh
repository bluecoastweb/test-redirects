#!/bin/sh

#-------------------------------------------------------------------------------
# Load testing library
#-------------------------------------------------------------------------------

. ./lib/test-redirects.sh

#-------------------------------------------------------------------------------
# Test multiple, dissimilar URLs
#-------------------------------------------------------------------------------

for send_and_expect in \
    "http://example.com/old/path http://foo.example.com/brand/new/path" \
    "http://example.com/login https://secure.example.com/sign-in"
do
    split_and_test_redirect $send_and_expect
done

#-------------------------------------------------------------------------------
# and print a summary of the results
#-------------------------------------------------------------------------------

print_summary
