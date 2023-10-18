

DROP TABLE IF EXISTS #temp_apartments;

WITH rank_cte AS( 

SELECT *,
	ROW_NUMBER() OVER (PARTITION BY [id] ORDER BY [id]) AS rank
FROM [ApartmentsPoland].[dbo].[apartments_pl_combined]
)

SELECT *
INTO #temp_apartments
FROM rank_cte
WHERE rank = 1;

SELECT * 
FROM #temp_apartments;




DROP TABLE IF EXISTS apartments_pl_cleaned;

SELECT 
	--[id]
	  CASE 
		  WHEN city = 'wroclaw' THEN 'WROC£AW'
		  WHEN city = 'poznan' THEN 'POZNA—'
		  WHEN city = 'krakow' THEN 'KRAK”W'
		  WHEN city = 'czestochowa' THEN 'CZ STOCHOWA'
		  WHEN city = 'lodz' THEN '£”Dè'
		  WHEN city = 'bialystok' THEN 'BIA£YSTOK'
		  WHEN city = 'gdansk' THEN 'GDA—SK'
	    ELSE TRIM(UPPER(city))
	  END AS city
	  ,CASE 
		  WHEN type = 'tenement' THEN 'Tenement'
		  WHEN type = 'blockOfFlats' THEN 'Block of flats'
		  WHEN type = 'apartmentbuilding' THEN 'Apartment Building'
		  WHEN type = '' THEN NULL
	  END AS building_type
	  ,CAST([squareMeters] AS DECIMAL(10, 1)) AS square_meters
      ,CAST(ROUND([rooms], 0) AS INT) AS rooms
      ,CAST(ROUND([floor], 0)AS INT) AS floor
      ,CAST(ROUND([floorCount], 0)AS INT) AS floor_count
      ,NULLIF(CAST(ROUND([buildYear], 0)AS INT), 0) AS build_year
      ,CAST([latitude] AS DECIMAL(12,9)) AS latitude
      ,CAST([longitude] AS DECIMAL(12,9)) AS longitude
      ,CONVERT(FLOAT, [centreDistance]) AS distance_centre_km
      ,CONVERT(FLOAT, [poiCount]) AS distance_poi_km
      ,CONVERT(FLOAT, [schoolDistance]) AS distance_school_km
      ,CONVERT(FLOAT, [clinicDistance]) AS distance_clinic_km
      ,CONVERT(FLOAT, [postOfficeDistance]) AS distance_post_office_km
      ,CONVERT(FLOAT, [kindergartenDistance]) AS distance_kindergarten_km
      ,CONVERT(FLOAT, [restaurantDistance]) AS distance_restaurant_km
      ,CONVERT(FLOAT, [collegeDistance]) AS distance_college_km
      ,CONVERT(FLOAT, [pharmacyDistance]) AS distance_pharmacy_km
      ,NULLIF([ownership], '') AS ownership
      ,NULLIF(buildingMaterial, '') AS building_material
      ,NULLIF(condition, '') AS building_condition
      ,[hasParkingSpace] AS has_parking_space
      ,[hasBalcony] AS has_balcony
      ,[hasElevator] AS has_elevator
      ,[hasSecurity] AS has_security
      ,[hasStorageRoom] AS has_storage_room
      ,CONVERT(DECIMAL(12,2), [price]) AS price_zl
INTO [ApartmentsPoland].[dbo].[apartments_pl_cleaned]
FROM #temp_apartments;



SELECT *
FROM [ApartmentsPoland].[dbo].[apartments_pl_cleaned];

