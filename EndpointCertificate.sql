/*
Note: 
	Port for Primary & Secondary : "5022"
	
By:
	Ghufran Khan
	FB: https://www.facebook.com/GhufranKhan89
	Youtube: https://bit.ly/36DQ87d
	GitHub: https://github.com/inditechie?tab=repositories
*/

-- Run on Primary node (First Step) :
 
CREATE LOGIN HA_Login WITH PASSWORD = 'P@assword@123';
 
CREATE USER HA_User FOR LOGIN HA_Login;
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@assword@123';
 
CREATE CERTIFICATE HA_Certificate AUTHORIZATION HA_User
	WITH SUBJECT = 'High Availability Certificate'
		,EXPIRY_DATE = '29991231';
 
BACKUP CERTIFICATE HA_Certificate
   TO FILE = 'C:\Temp\HA_Certificate.cer'
   WITH PRIVATE KEY (
           FILE = 'C:\Temp\HA_Certificate.pvk',
           ENCRYPTION BY PASSWORD = 'P@assword@123'
       );
 
CREATE ENDPOINT [Hadr_endpoint]
    AS TCP (LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
	    ROLE = ALL,
	    AUTHENTICATION = CERTIFICATE HA_Certificate WINDOWS NEGOTIATE,
		ENCRYPTION = REQUIRED ALGORITHM AES
		);
 
ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
 
GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO PUBLIC;
 
GO
 
 
-- Copy the HA_Certificate.cer & HA_Certificate.pvk to Secondary node in "C:\Temp\" from Primary/Principal
-- Run on Secondary node (Second Step) :
 
CREATE LOGIN HA_Login WITH PASSWORD = 'P@assword@123';
 
CREATE USER HA_User FOR LOGIN HA_Login;
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@assword@123';
 
CREATE CERTIFICATE HA_Certificate
    AUTHORIZATION HA_User
    FROM FILE = 'C:\Temp\HA_Certificate.cer'
    WITH PRIVATE KEY (
    FILE = 'C:\Temp\HA_Certificate.pvk',
    DECRYPTION BY PASSWORD = 'P@assword@123'
            );
 
CREATE ENDPOINT [Hadr_endpoint]
    AS TCP (LISTENER_PORT = 5022)
    FOR DATA_MIRRORING (
	    ROLE = ALL,
	    AUTHENTICATION = CERTIFICATE HA_Certificate WINDOWS NEGOTIATE,
		ENCRYPTION = REQUIRED ALGORITHM AES
		);
 
ALTER ENDPOINT [Hadr_endpoint] STATE = STARTED;
 
GRANT CONNECT ON ENDPOINT::[Hadr_endpoint] TO PUBLIC;
 
GO