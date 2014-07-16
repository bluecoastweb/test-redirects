#-------------------------------------------------------------------------------
# Purpose: Bulk test HTTP redirects
#
# Dependencies: cURL
#
# Example:
#-------------------------------------------------------------------------------

#   . ~/lib/test-redirects.sh
#
#   test_redirect http://example.com/foo/bar http://foo.example.com/bar

#-------------------------------------------------------------------------------
# Example: multiple, similar URLs
#-------------------------------------------------------------------------------

#   . ~/lib/test-redirects.sh
#
#   base_url=http://example.com
#
#   for send_and_expect in \
#       "foo bar" \
#       "fizz boom"
#   do
#       "old/path brand/new/path" \
#       "hello/world goodbye/cruel/world"
#
#       test_redirect $base_url/$send $base_url/$expect
#   done
#
#   print_summary

#-------------------------------------------------------------------------------
# Example: multiple, dissimilar URLs
#-------------------------------------------------------------------------------

#   . ~/lib/test-redirects.sh
#
#   for send_and_expect in \
#       "http://example.com/old/path http://foo.example.com/brand/new/path" \
#       "http://example.com/login https://secure.example.com/sign-in"
#   do
#       split_and_test_redirect $send_and_expect
#   done
#
#   print_summary

succeeded=0
failed=0
total=0

test_redirect() {
    send=$1
    expect=$2

    echo -n $send

    curl_out=`curl -sL -w "%{http_code}\t%{url_effective}" -o /dev/null $send`

    http_code=`echo "$curl_out" | cut -f1`
    receive=`  echo "$curl_out" | cut -f2`

    total=`expr $total + 1`

    if [ "$http_code" != "200" ]; then
      echo " ERROR ($http_code) $receive"
      failed=`expr $failed + 1`
      return 1

    elif [ -n "$expect" ] && [ "$receive" != "$expect" ]; then
      echo " ERROR ($http_code) $receive"
      failed=`expr $failed + 1`
      return 1

    fi

    echo " --> $receive"
    succeeded=`expr $succeeded + 1`
    return 0
}

split_and_test_redirect() {
    send=`  echo $1 | cut -f1 -d" "`
    expect=`echo $1 | cut -f2 -d" "`

    test_redirect $send $expect
}

print_summary() {
    echo "Succeeded: $succeeded, Failed: $failed, Total: $total"
}
