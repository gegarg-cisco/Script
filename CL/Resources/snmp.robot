*** Settings ***
Library  SSHLibrary

*** Keywords ***
Open Connection and Log In
    open connection  ${host}
    login  ${user}  ${pass}