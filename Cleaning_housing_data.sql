-- CLEANING DATA IN SQL QUERIES

SELECT * FROM HOUSING_PR

--Modifying SALEDATE

Select SaleDate, CONVERT (DATE, SaleDate)
FROM HOUSING_PR

--UPDATE HOUSING_PR
--SET SaleDate = CONVERT(DATE, SaleDate)

ALTER TABLE HOUSING_PR
ADD SaleDateConverted DATE;

UPDATE HOUSING_PR
SET SaleDateConverted = CONVERT(DATE, SaleDate)

Select SaleDateConverted
FROM HOUSING_PR

--populate property Address data USING parcel ID
Select*
FROM HOUSING_PR

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HOUSING_PR a
JOIN HOUSING_PR b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM HOUSING_PR a
JOIN HOUSING_PR b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

--Breaking out ADDRESS INTO  Individual Columns (address, city, state)

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM HOUSING_PR

ALTER TABLE HOUSING_PR
ADD PropertySplitAddress NVARCHAR(255);

UPDATE HOUSING_PR
SET PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE HOUSING_PR
ADD PropertySplitCity NVARCHAR(255);

--UPDATE HOUSING_PR
--SET PropertySplitCity = (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
UPDATE HOUSING_PR
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1
, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress))

SELECT*FROM HOUSING_PR

-- Add new columns for Address, City, and State
ALTER TABLE HOUSING_PR 
ADD Address NVARCHAR(100), 
    City NVARCHAR(50), 
    State NVARCHAR(50);

-- Update the table with separated values
UPDATE HOUSING_PR
SET 
    Address = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    City = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    State = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--Change Y AND N TO YES AND NO IN 'SOLDasVacant' field
SELECT DISTINCT (SoldAsVacant), Count(SoldAsVacant)
FROM HOUSING_PR
GROUP BY SoldAsVacant
Order by 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM HOUSING_PR

Update HOUSING_PR
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--PEMOVE DUPLICATES
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY PropertyAddress,
		                                    SaleDate,
											SalePrice,
											LegalReference,
											OwnerName,
											ParcelID
                              ORDER BY  UniqueID) AS RowNum
    FROM HOUSING_PR
	)
	DELETE
	From RowNumCTE 
	WHERE RowNum>1
	--ORDER BY PropertyAddress


	--DELETE UNUSED COLUMNS
	Select * from HOUSING_PR

	ALTER TABLE HOUSING_PR
	DROP COLUMN SaleDate, OwnerAddress,TaxDistrict, PropertyAddress


	ALTER TABLE HOUSING_PR
	DROP COLUMN  Address, City






