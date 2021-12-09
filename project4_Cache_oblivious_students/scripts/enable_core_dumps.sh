# Enable core dumps on Ubuntu
# These are usually flipped off,
# and even when they're turned on
# they go to apport which is annoying
#
# This script turns that off. It
# won't persist through a reboot though.

set -eux
ulimit -S -c unlimited
sudo sysctl -w kernel.core_pattern=/tmp/core-%e.%p.%h.%t
