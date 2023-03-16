--The dataset beng used is for Nashville housing. We'll be using various methods to clean the data.
USE SQLPortfolioProject2
SELECT * FROM nash_housing

--We'll start with standardizing the date format and making it a little more compact and readale

SELECT SaleDate FROM nash_housing

UPDATE nash_housing
SET Saledate=CONVERT(DATE,SaleDate)

SELECT 
	SaleDate,
	CONVERT(DATE,SaleDate) AS Cleaned_SaleDate
FROM
	nash_housing


--Clean the property address data that is missing

SELECT *
FROM nash_housing
ORDER BY ParcelID


SELECT a.ParcelID,
	a.PropertyAddress,
	b.ParcelID, 
	b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress) AS missing_property_address
FROM 
	nash_housing a
JOIN 
	nash_housing b
ON
	a.ParcelId=b.ParcelID
AND
	a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
	nash_housing a
JOIN 
	nash_housing b
ON
	a.ParcelId=b.ParcelID
AND
	a.UniqueID<>b.UniqueID
WHERE a.PropertyAddress IS NULL


--Split the address into street address and city

SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 
FROM
	nash_housing


ALTER TABLE nash_housing
ADD PropertyCity NVARCHAR(255)


UPDATE nash_housing
SET PropertyCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

UPDATE nash_housing
SET PropertyAddress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


--Formatting the SoldAsVacant column for better data integrity

SELECT 
	SoldAsVacant,
CASE
	WHEN SoldAsVacant='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
ELSE SoldAsVacant
END AS cleaned_vacancy_data
FROM 
	nash_housing


UPDATE nash_housing
SET SoldAsVacant='Yes'
WHERE SoldAsVacant='Y'

UPDATE nash_housing
SET SoldAsVacant='No'
WHERE SoldAsVacant='N'


