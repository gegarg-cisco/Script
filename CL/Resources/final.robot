*** Settings ***
Documentation                               This is basic test to verify networks
Resource                                    /Users/gegarg/PycharmProjects/Script/CL/Variables/final.robot
Library                                     SSHLibrary
Library                                     String
Library             SSHLibrary


*** Keywords ***
Open Connection And Log In
   Open Connection     ${HOST}
   Login               ${USERNAME}        ${PASSWORD}
   #Open Connection     ${server}    alias=server
   #Login               ${user}        ${pass}


Verify Config
    ${output}=  execute command   sh run snmp
    log  ${output}
    should contain  ${output}  snmp-server community public
    ${output}=  execute command  ping ${server_ip} vrf management
    should contain  ${output}  0.00% packet loss

interface MTU
    Open Connection And Log In
    ${byte}=  execute command   show interface ${int}
    ${byte}=  Get Lines Containing String    ${byte}    MTU
    ${byte}=     fetch from left  ${byte}    bytes
    ${index}=  execute command   sh interface snmp-ifindex
    log  ${index}
    ${index}=  Get Lines Containing String   ${index}    ${int}
    ${index}=  Fetch From Left    ${index}  (
    ${index}=  Fetch From Right    ${index}  ${int}
    ${index} =	strip string    ${SPACE}${index}${SPACE}
    mtu snmpwalk    ${index}    ${byte}

mtu snmpwalk
    [Arguments]  ${index}   ${byte}
    Connect to server
    ${output}=  execute command  snmpwalk -v 2c -c public ${ip} 1.3.6.1.2.1.2.2.1.4
    log  ${output}
    ${get}=  Get Lines Containing String   ${output}    ifMtu.${index}
    ${index1}=  Fetch From Right    ${get}  :
    Should Contain  ${byte}  ${index1}

Connect to server
   Open Connection     ${server}
   Login               ${user}        ${pass}

Mib walk
    #switch connection  ${conn}
    Connect to server
    [Arguments]  @{mib}
    :FOR    ${mi}     IN      @{mib}
    \   ${output}=  execute command  snmpwalk -v 2c -c public  ${ip} ${mi}
    \   log  ${output}

Tcp snmpwalk
    Connect to server
    ${output}=  execute command  snmpwalk -v 2c -c public ${ip} 1.3.6.1.2.1.6
    log  ${output}
    should not contain  ${output}   Timeout
    should not contain  ${output}   Unknown Object Identifier




cpu snmpwalk 1 min
    Connect to server
    ${output}=  execute command     snmpwalk -v 2c -c public ${ip} 1.3.6.1.4.1.9.9.109.1.1.1.1.7
    #${b}=  Get Lines Containing String    ${output}    4097 = Gauge32:
    ${cpu}=     fetch from right  ${output}    :
    Should Be True	${cpu} < 20
    #Should Contain  ${byte}  ${b}

Verify Trap
    Connect to server
    ${output}=  execute command     cat /var/log/snmptrapd.log
    log  ${output}
    Should Contain  ${output}   sysUpTimeInstance

