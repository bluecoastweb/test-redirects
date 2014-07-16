#!/bin/sh

#-------------------------------------------------------------------------------
# Load testing library
#-------------------------------------------------------------------------------

. ./lib/test-redirects.sh

#-------------------------------------------------------------------------------
# Test multiple, similar URLs
#-------------------------------------------------------------------------------

base_url=http://example.com

for send_and_expect in \
    "old/path brand/new/path" \
    "hello/world goodbye/cruel/world"
do
    send=`  echo $send_and_expect | cut -f1 -d" "`
    expect=`echo $send_and_expect | cut -f2 -d" "`

    test_redirect $base_url/$send $base_url/$expect
done

#-------------------------------------------------------------------------------
# and print a summary of the results
#-------------------------------------------------------------------------------

print_summary
