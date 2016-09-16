# tdn

# **Affected devices**

The **TEW-828 DRU** is the very last model from TRENDnet. It is an expensive trial-band device that can reach 3200Mbps (cumulated) 

The **TEW-818 DRU** was launched just before the 828. It is an expensive device too with a "abgn" dual-band Technology. It can reach 1900Mbps.   

# **WPS disclosure**

  The default WPS PIN for both models is generated with the six last digits from the 2.4Ghz bSSID (equal to half end of 5 GHz bSSID minus 4 )
  
  The 2 first digits of this portion of the BSSID are inverted with the two last digits
  
  Than the string is converted from hexadecimal to decimal.
  
  Some zero-padding is done to get a 7 digits strings if the value obtained after conversion to decimal is inferior to 1000000.
  In the case that the value of the string after conversion is superior to 9999999, the first digit is removed.
  
  At the end the string is always 7 decimal digit long in order to generate porperly a WPS checksum that is added at the end to create a 8 digit WPS PIN.
  
  Three more elements should be pointed out :  
  1. WPS is enabled by default
  2. The default PIN is unique, it is the same for 2.4 Ghz and 5 Ghz networks  
  3. The default PIN is unconfigurable, it cannot be changed
  
**For more details please check the original full-disclosures**

  1. https://packetstormsecurity.com/files/132477/TRENDnet-TEW-818RDU-PIN-Disclosure.html (English) *
  2. https://www.wifi-libre.com/topic-160-algoritmo-pin-tew-818dru-ac1900-y-tew-828dru-ac3200-de-trendnet.html (Spanish)
  3. http://www.crack-wifi.com/forum/topic-10657-trendnet-tew-818dru-ac19000-full-disclosure-wps-pin.html (French ) 
  
(*) There is an error in the english version, it is not tew818DRU v1 and v2 but , as it is sayed here, TEW-818DRU & TEW-828DRU

# **HOW TO USE tdn.sh** (bash version)

It is a very simple bash script that can be run in any GNU-Linux ditribution. No dependencies needed :

1. download and unzip this repository branch

2. locate a shell in the unziped directory with <code>cd</code>

3. launch the script by invoking bash <code>bash tdn.sh</code>

4. Introduce (as prompted in the shell) the **full 2.4 Ghz BSSID in it original format** ( 6 pairs of hexadecimal digits separated by two points ":" ) 
