CREATE PROCEDURE [dbo].[UMAC_CERT_OPEN_KEY]
AS
BEGIN
    BEGIN TRY
        OPEN SYMMETRIC KEY UMAC_CERT_KEY DECRYPTION BY CERTIFICATE UMAC_CERT;
    END TRY
    BEGIN CATCH
        -- Handle non-existant key here
    END CATCH
END

GO

