/*

Cleaning data in SQL queries

*/
Select * from PortfolioProject..house

 ------------------------------------------------------------------------------------------------------------------------

 --Standardize Date Format

 Select SaleDate, Convert(date,SaleDate) from PortfolioProject..house

 ALTER TABLE house
 Add SaleDateConv date;

 UPDATE house
 SET SaleDateConv = Convert(date,SaleDate)


 --Populate Property Address Data

 Select * from PortfolioProject..house
 Order by ParcelID

 SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject..house a
 join PortfolioProject..house b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
 Where a.PropertyAddress is NULL

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProject..house a
 join PortfolioProject..house b
 ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
 Where a.PropertyAddress is NULL


 --Breaking out Address into Individual Columns (Address, City, State)

 Select PropertyAddress from PortfolioProject..house
 
 Select
 SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) - 1) as Address,
 SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
 from PortfolioProject..house

 ALTER TABLE house
 Add PropertySplitAddress nvarchar(255);

 UPDATE house
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress) - 1)

 ALTER TABLE house
 Add PropertySplitCity nvarchar(255);

 UPDATE house
 SET PropertySplitCity = SUBSTRING(PropertyAddress, Charindex(',', PropertyAddress) + 1, LEN(PropertyAddress))

 Select * from PortfolioProject..house

 Select OwnerAddress from PortfolioProject..house

 SELECT
 PARSENAME(REPLACE (OwnerAddress, ',', '.'), 3),
 PARSENAME(REPLACE (OwnerAddress, ',', '.'), 2),
 PARSENAME(REPLACE (OwnerAddress, ',', '.'), 1)
 From PortfolioProject..house

  ALTER TABLE house
 Add OwnerSplitAddress nvarchar(255);

 UPDATE house
 SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 3)

 ALTER TABLE house
 Add OwnerSplitCity nvarchar(255);

 UPDATE house
 SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 2)

  ALTER TABLE house
 Add OwnerSplitState nvarchar(255);

 UPDATE house
 SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress, ',', '.'), 1)


--Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..house
group by SoldAsVacant
Order by 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM PortfolioProject..house

UPDATE house
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


--Remove Duplicates
WITH RowNumCTE AS(
SELECT * ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM PortfolioProject..house
)

DELETE
FROM RowNumCTE
WHERE row_num > 1


--Delete Unwanted Columns

ALTER TABLE PortfolioProject..house
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate