SELECT
  rf.rfamseq_acc,
  rf.length,
  tx.ncbi_id,
  tx.tax_string
FROM rfamseq rf
JOIN taxonomy tx ON rf.ncbi_id = tx.ncbi_id
WHERE tx.tax_string LIKE '%Oryza%'     -- matches genus / species containing "Oryza"
ORDER BY rf.length DESC
LIMIT 1;
