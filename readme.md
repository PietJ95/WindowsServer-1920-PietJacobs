# Opdracht Windows server

U bent IT-Consultant en krijgt de vraag om een voorstel te maken en te demonstreren van een Windowsomgeving.
Deze omgeving moet bestaan uit het volgende .
De cliënt wenst een redundante oplossing voor zijn servers. Dit vooral op de domeincontrollers. Je gaat er voor zergen dat de client een oplossing heeft voor Mail (Exchange), Automatische deplyement van tostellen (SCCM – MDT). Je zal ook SharePoint als oplossing installeren. 
U krijgt dus volgende situatie  dewelke u zoveel mogelijk zal automatiseren via PowerShell scripting
## 2 Domeincontrollers die bestaan uit Windows 2019 met volgende specificaties
- OS: Windows 2019
- NAAM domain controller 1: WIN-DC1
    - IP instellingen WIN-DC1
        - 1 NIC op NAT
        - 1 NIC op intern netwerk met volgende IP configuratie
            -	IP: 192.168.100.10
            -	SN: 255.255.255.0

- NAAM domain controller 2: WIN-DC2
    - IP instellingen WIN-DC2
    - 1 NIC op Intern netwerk
        - IP: 192.168.100.20
        - SN: 255.255.255.0
        - DG: 192.168.100.10
##	SQL server
- OS: Windows 2019
-	Naam SQL Server: WIN-SQL-SCCM
-	Versie SQL versie 2017
-	IP instellingen SQL server
	- 1 NIC op intern netwerk
        - IP: 192.168.100.30
        - SN: 255.255.255.0
        - DG: 192.168.100.10
##	Exchange server
OS: Windows 2019  
Naam SQL Server: WIN-EXC-SHP  
Versie Exchange: 2016  
IP instellingen Exchange:
- 1 NIC op intern netwerk
    - IP: 192.168.100.40
    - SN: 255.255.255.0
	- DG: 192.168.100.40
 
##	Deployment server
OS: Windows 2019  
Naam: WIN-SQL-SCCM  
Versie SCCM: 2016
IP instellingen Deployment  
1 NIC op intern netwerk
- IP: 192.168.100.30
- SN: 255.255.255.0
- DG: 192.168.100.30

## SharePoint server
OS Windows 2019  
Naam SQL Server: WIN-EXC-SHP  
Versie SharePoint: 2016
IP instellingen Exchange  
1 NIC op intern netwerk
- IP: 192.168.100.40
- SN: 255.255.255.0
- DG: 192.168.100.40

## Windows Cliënt
OS: Windows 10  
Naam client: WIN-CLT1  
IP: via DHCP van de DC1 of DC2  
Office software om te mailen  
 
##	Bijkomende specificaties
- Domeinnaam voor deze opstelling: uw naam.periode1  
    - Voorbeeld: thijs.periode1

- Configureer op uw DC 1 de routerfaciliteiten zodat uw intern netwerk via de DC1 op het internet kan.  
- Zorg ook dat DNS op alle servers wordt ingesteld op 192.168.100.10

## Opdracht specifiek servers
### Deployment server:
- Moet mogelijk zijn om een Windows Cliënt te installeren via een image
- Moet mogelijk zijn om Adobe reader te deployen op een Windows toestel via een package (msi of iets dergelijks)
- Beheers uw updates via de SCCM deployment omgeving

### SharePoint server
- Installatie en configuratie voor een intranet site. Niet toegankelijk van buitenuit
- Zorg dat de active directory security groepen deze kunnen gebruiken.

## Evaluatie
Als documentatie zorgt u voor een volledige installatiehandleiding van alle verschillende servers en clients. U voegt ook uw scripts bij het portfolio.
Voorafgaand aan de mondelinge verdediging in de examen periode zal u uw portfolio inleveren via chamilo op 27 december ten laatste. 
