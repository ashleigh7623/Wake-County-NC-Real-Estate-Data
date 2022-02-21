--Cleaning Data in SQL Queries

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [OWNER1]
      ,[OWNER2]
      ,[Mailing_address1]
      ,[Mailing_Address2]
      ,[Mailing_Address3]
      ,[REAL_ESTATE_ID]
      ,[CARD_NUMBER]
      ,[NUMBER_OF_CARDS]
      ,[Street_Number]
      ,[Street_Prefix]
      ,[Street_Name]
      ,[Street_Type]
      ,[Street_Suffix]
      ,[Planning_Jurisdiction]
      ,[Street_Misc]
      ,[Township]
      ,[Fire_District]
      ,[Land_Sale_Price]
      ,[Land_Sale_Date]
      ,[Zoning]
      ,[Deeded_Acreage]
      ,[Total_sale_Price]
      ,[Total_Sale_Date]
      ,[Assessed_Building_Value]
      ,[Assessed_Land_Value]
      ,[Parcel_Identification]
      ,[Special_District1]
      ,[Special_District2]
      ,[Special_District3]
      ,[BILLING_CLASS]
      ,[PROPERTY_DESCRIPTION]
      ,[Land_classification]
      ,[DEED_BOOK]
      ,[DEED_PAGE]
      ,[Deed_Date]
      ,[VCS]
      ,[PROPERTY_INDEX]
      ,[Year_Built]
      ,[NUM_of_Rooms]
      ,[UNITS]
      ,[HEATED_AREA]
      ,[UTILITIES]
      ,[Street_pavement]
      ,[TOPOGRAPHY]
      ,[Year_of_Addition]
      ,[Effective_year]
      ,[Remodeled_Year]
      ,[Special_Write_In]
      ,[Story_Height]
      ,[DESIGN_STYLE]
      ,[Foundation_Basement]
      ,[Foundation_Basement_Percent]
      ,[Exterior_Wall]
      ,[COMMON_WALL]
      ,[ROOF]
      ,[Roof_Floor_System]
      ,[Floor_Finish]
      ,[Interior_Finish]
      ,[Interior_Finish1]
      ,[Interior_Finish1_percent]
      ,[Interior_Finish2]
      ,[Interior_Finish2_percent]
      ,[HEAT]
      ,[HEAT_PERCENT]
      ,[AIR]
      ,[AIR_PERCENT]
      ,[BATH]
      ,[BATH_FIXTURES]
      ,[Built_in1_Description]
      ,[Built_in2_Description]
      ,[Built_in3_Description]
      ,[Built_in4_Description]
      ,[Built_in5_Description]
      ,[CITY]
      ,[GRADE]
      ,[Assessed_Grade_Difference]
      ,[Accrued_Assessed_Condition_Pct]
      ,[Land_Deferred_code]
      ,[Land_Deferred_Amount]
      ,[Historic_Deferred_code]
      ,[Historic_Deferred_Amount]
      ,[RECYCLED_UNITS]
      ,[Disq_and_Qual_flag]
      ,[Land_Disq_and_Qual_flag]
      ,[TYPE_AND_USE]
      ,[PHYSICAL_CITY]
      ,[PHYSICAL_ZIP_CODE]
  FROM [WakeCountyHousing].[dbo].[WCHousing]

  Select * 
  From WakeCountyHousing.dbo.WCHousing

  --Standardize Date Format

  Select Total_Sale_Date, CONVERT(Date,Total_Sale_Date)
  From WakeCountyHousing.dbo.WCHousing

  UPDATE WCHousing 
  SET Total_Sale_Date = CONVERT(Date,Total_Sale_Date)

  ALTER TABLE WCHousing
  ADD SaleDate Date;

  UPDATE WCHousing 
  SET SaleDate = CONVERT(Date,Total_Sale_Date)

  Select SaleDate, CONVERT(Date,Total_Sale_Date)
  From WakeCountyHousing.dbo.WCHousing



--Populate Property Address data

  Select PropertyAddress
  From WakeCountyHousing.dbo.WCHousing
  WHERE PropertyAddress is null

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  From WakeCountyHousing.dbo.WCHousing a
  JOIN WakeCountyHousing.dbo.WCHousing b
	on a.ParcelID = b.ParcelID
	AND a.[REAL_ESTATE_ID] <> b.[REAL_ESTATE_ID]
  WHERE a.PropertyAddress is null

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 From WakeCountyHousing.dbo.WCHousing a
  JOIN WakeCountyHousing.dbo.WCHousing b
	on a.ParcelID = b.ParcelID
	AND a.[REAL_ESTATE_ID] <> b.[REAL_ESTATE_ID]
 WHERE a.PropertyAddress is null


 --Remove Duplicates

 WITH RowNumCTE AS(
 Select *,
	ROW_NUMBER() OVER (
	PARTITION BY PropertyAddress,
				 ParcelID
				 ORDER BY REAL_ESTATE_ID
					) row_num

 From WakeCountyHousing.dbo.WCHousing
 )
--Replace "Select" with "Delete"
Select *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--Deleting Unused Columns

  Select * 
  From WakeCountyHousing.dbo.WCHousing

  ALTER TABLE WakeCountyHousing.dbo.WCHousing
  DROP COLUMN Special_District2, Special_District3, Street_pavement, TOPOGRAPHY, Floor_Finish, Interior_Finish, 

  ALTER TABLE WakeCountyHousing.dbo.WCHousing
  DROP COLUMN Interior_Finish1, Interior_Finish1_percent, Interior_Finish2,Interior_Finish2_percent,
				Land_Deferred_code, Historic_Deferred_code

