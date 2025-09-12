<h1>Active Directory Home Lab Steps:</h1>


<h2>Step 1: Configure Server 2022 on VirtualBox</h2>

• Mounted Windows Server 2022 ISO

• Adapter 1 (External): By configuring the NIC with NAT, the DC can use the home router to access the internet. NAT will also allow internal clients the ability to access the internet by going through the external adapter on the DC.

• Adapter 2 (Internal): This adapter connects the DC to the internal lab network. This NIC acts as the gateway and DNS server for the internal lab network. Additionally, this NIC is how internal clients will access DHCP to obtain their network settings.

<h2>Step 2: Configure Domain Controller IP Address</h2>

• The Internal NIC is configured with a static IP address of 172.16.0.1, allowing internal clients to use this IP address as their gateway. The gateway field is left blank because the External NIC on the DC manages internet routing through NAT. A loopback address is used for the DNS server address, allowing the DC to utilize its own DNS service.

<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/912c62c5-93c4-44c3-8ee1-31e8c200f380" alt="Image of Windows IP config menu"/>
<br />
<br />

<h2>Step 3: Promote the Server to Domain Controller</h2>

• Installed the Active Directory Domain Services server role and promoted the server to the DC with a domain name of “mydomain.com”. The server is now set up to supply domain clients with authentication, authorization, and directory services.

<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/047a0f31-2e9c-49bc-b49c-5bf6dd83419f" alt="Image of AD domain"/>
<br />
<br />


<h2>Step 4: Configure NAT on the DC</h2>

• After installing the Remote Access server role, NAT was configured on the domain controller, allowing internal clients to access the Internet by translating their private IP addresses into the DC’s public IP.

<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/117effbe-8dd4-4daa-b18c-475c2c858097" alt="Image of configured Remote Access server role" />
<br />
<br />

<h2>Step 5: Configure the DHCP Scope</h2>

• Installed the DHCP server role and configured the DHCP scope on the DC to assign IP addresses to the internal clients. 

Scope Range: 172.16.0.100 – 172.16.0.200

Subnet Mask: 255.255.255.0

Gateway: 172.16.0.1

DNS: 172.16.0.1


<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/7e0d5c41-82a2-4286-b027-9e7d97821f6c" alt="Image of DHCP server role menu" />
<br />
<br />

<h2>Step 6: Create AD Users with PowerShell</h2>

• A script was used to take a text file of 1000 first and last names and generate AD users for each name.


<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/877c7b8b-c1c7-4ace-bbff-72a31f6c919d" alt="Image of Powershell script"/>
<br />
<br />

<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/5fa59761-9d82-45bd-b9a2-6354508ed1ff" alt="Image of newly created AD users"/>
<br />
<br />

<h2>Step 7: Joined a Windows 10 client to the domain</h2>

• Mounted Windows 10 ISO

• Adapter 1 (Internal): By setting the NIC to Internal, the DC can provide the client with DHCP, DNS, and AD services.

• By using the ipconfig and ping commands, I verified that the DHCP and DNS servers were functioning properly. Using the Computer Name menu, the client was joined to the “mydomain.com” domain. After this, I was able to log in successfully with a domain account.


<p align="center">
<img width="80%" height="80%" alt="Image" src="https://github.com/user-attachments/assets/35199002-0f5b-4c47-b197-0079d9530d5b" alt="Image of newly joined Client to the domain"/>
<br />
<br />

