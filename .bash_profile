#
# ~/.bash_profile
#
if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi

if [[ $- == *i* ]]; then
   source /usr/share/blesh/ble.sh --noattach 
fi

if [[ ${BLE_VERSION-} ]]; then
   ble-attach 
fi
