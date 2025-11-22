-- Find all types of tigers
SELECT ncbi_id, species, tax_string
FROM taxonomy
WHERE species LIKE '%tigr%' OR tax_string LIKE '%Panthera tigris%';

-- For Sumatran Tiger specifically (biological name: Panthera tigris sumatrae)
SELECT ncbi_id, species
FROM taxonomy
WHERE species LIKE '%Panthera tigris sumatrae%' 
   OR species LIKE '%sumatrae%';