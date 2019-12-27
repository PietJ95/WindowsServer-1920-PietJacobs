# Handleiding installatie DC1
Prerequisites:
- Virtualbox software
- Windows Server 2016 ISO file
- Voldoende RAM geheugen om VM's te runnen


## Stap 1: VM aanmaken & configureren

### Adapters instellen
Deze VM mag maar 1 adapter hebben. Ga naar `Instellingen` en onder het tabblad `Netwerk` verander je de `NAT`-interface naar `Host-Only Adapter` (hetzelfde nummer als bij WIN-DC1).

### Andere instellingen
In de opgave stond er dat we een Windows Server 2019 OS moesten runnen met Exchange 2016 op. Helaas is dit niet supported door Windows: https://docs.microsoft.com/en-us/windows-server/get-started-19/app-compat-19

We gaan dus gebruik maken van Windows Server 2016.  
Volg de [handleiding](./WIN-DC1.md#Stap1) van WIN-DC1 voor:
- Correcte instellingen van de VM in Virtualbox
- een VM aanmaken en installeren met het OS, maar geef nu de Windows Server 2016 ISO mee in plaats van de 2019 ISO.
- shared folder aanmaken (nu voor de map `WIN-EXC-SHP`)

---

## Stap 2: Scripts runnen
**BELANGRIJK**: `WIN-DC1` moet up en running zijn voor een correcte installatie!

- Rechtermuis op `Step1` en klik op `Run with PowerShell`
- Indien je een melding krijgt ivm. `Execution Policy Change` dan typ je `A` en druk je op `enter`
- Meerdere reboots zijn mogelijk, telkens opnieuw inloggen met je gekozen wachtwoord

**Opmerking**: Deze installatie kan heel lang duren naargelang de snelheid van je computer en het internet. Ook hier zijn meerdere reboots aanwezig.