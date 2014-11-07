 ALTER PROCEDURE [dbo].[proc_get_assetprofile_byid]      
(      
 @pk_asset_id uniqueidentifier  ='154C01C6-7186-410F-84B2-A715912C8F43'    
)      
AS      
      
BEGIN      
 DECLARE @WarrantyStartDate AS nvarchar(max)      
 DECLARE @InstallationDate AS nvarchar(max)     
 DECLARE  @WarrantyEndDate AS nvarchar(max)     
       
 declare @IsLinkedInBIM AS nvarchar(max)      
       
 set @IsLinkedInBIM=case when      
            (isnull((select top 1 fk_external_system_data_id from tbl_external_system_asset_linkup       
                     INNER JOIN tbl_extrnal_system_configuration tesc       
                     ON tesc.pk_external_system_configuration_id=tbl_external_system_asset_linkup.fk_external_system_configuration_id      
        INNER JOIN vw_get_external_system  vges ON vges.pk_external_system_id=tesc.fk_external_system_id      
                    WHERE vges.external_system_name in ('Revit','Bentley')and fk_ecodomus_system_data_id =@pk_asset_id),'')!= ''       
                  
            ) then      
   'Yes'      
   else      
   'No'      
 END      
 PRINT @IsLinkedInBIM      
       
 SET @InstallationDate = (      
               SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'InstallationDate'      
               ORDER BY      
                      1 DESC      
 )      
       
 IF isdate(@InstallationDate)=1      
 BEGIN      
  SET  @InstallationDate = CONVERT(VARCHAR(20),CONVERT (Datetime,@InstallationDate), 1)      
 END      
 ELSE      
 BEGIN      
   SET @InstallationDate=''      
 END      
       
       
 SET @WarrantyStartDate = (      
  SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'Warranty Start Date'      
               ORDER BY      
                      1 DESC      
 )    
     
     
       
       
 IF isdate(@WarrantyStartDate)=1    
 BEGIN      
  SET @WarrantyStartDate = CONVERT(VARCHAR(20),CONVERT (Datetime,@WarrantyStartDate), 1)      
 END      
 ELSE      
 BEGIN      
   set @WarrantyStartDate=''      
 END      
     
     
     
 SET @WarrantyEndDate = (      
  SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'Warranty End Date'      
               ORDER BY      
                      1 DESC      
 )    
     
 --Warranty End Date Added by  Sumeet For Task 1  
  IF isdate(@WarrantyEndDate)=1      
 BEGIN      
  SET  @WarrantyEndDate = CONVERT(VARCHAR(20),CONVERT (Datetime,@WarrantyEndDate), 1)      
 END      
 ELSE      
 BEGIN      
   SET @WarrantyEndDate=''      
 END      
     
     
       
    SELECT ta.pk_asset_id,      
           ta.fk_facility_id,      
           ta.fk_type_id,      
           ta.fk_uploaded_file_id,      
           ta.name,      
           ta.description,      
           tt.name AS TypeName,      
                 
                 
                 
                 
           (      
             SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'SerialNumber'      
               ORDER BY      
                      1 DESC      
           ) AS SerialNumber,      
           (      
               SELECT TOP 1  value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'Tagnumber'      
               ORDER BY      
                      1 DESC      
           ) AS Tagnumber,      
          --(      
          --     SELECT TOP 1 value      
          --     FROM   tbl_asset_attribute_value tlav      
          --     INNER JOIN   tbl_asset_attribute      
          --       ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
          --     INNER JOIN   tbl_asset ta2      
          --       ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
          --     WHERE  ta2.pk_asset_id = @pk_asset_id      
          --       AND  tbl_asset_attribute.name = 'InstallationDate'      
          --     ORDER BY      
          --            1 DESC      
          -- ) AS InstallationDate,      
               
          @InstallationDate AS InstallationDate      
                    
          ,      
           (      
               SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'Barcode'      
               ORDER BY      
                      1 DESC      
           ) AS Barcode,      
           -- (      
           --    SELECT TOP 1 value      
           --    FROM   tbl_asset_attribute_value tlav      
           --    INNER JOIN   tbl_asset_attribute      
           --      ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
           --    INNER JOIN   tbl_asset ta2      
           --      ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
           --    WHERE  ta2.pk_asset_id = @pk_asset_id      
           --      AND  tbl_asset_attribute.name = 'WarrantyStartDate'      
           --    ORDER BY      
           --           1 DESC      
           --) AS WarrantyStartDate,      
               @WarrantyStartDate AS WarrantyStartDate,     
               @WarrantyEndDate AS   WarrantyEndDate,          
                 
             
           (      
               SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'AssetIdentifier'      
               ORDER BY      
                      1 DESC      
           ) AS AssetIdentifier,      
           (    
            SELECT TOP 1 value      
               FROM   tbl_asset_attribute_value tlav      
               INNER JOIN   tbl_asset_attribute      
                 ON   tbl_asset_attribute.pk_asset_attribute_id = tlav.fk_asset_attribute_id      
               INNER JOIN   tbl_asset ta2      
                 ON   ta2.pk_asset_id = tbl_asset_attribute.fk_asset_id      
               WHERE  ta2.pk_asset_id = @pk_asset_id      
                 AND  tbl_asset_attribute.name = 'ConditionType'      
               ORDER BY      
                      1 DESC       
           )AS ConditionType,      
                 
          @IsLinkedInBIM as AssetIsLinkedInBIM      
    FROM   tbl_asset ta      
    inner JOIN   tbl_type tt      
      ON   tt.pk_type_id = ta.fk_type_id      
            
      
            
    WHERE  ta.pk_asset_id = @pk_asset_id      
END 